package fcj.dntu.vn.backend.services.impl;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import fcj.dntu.vn.backend.models.*;
import fcj.dntu.vn.backend.repositories.*;
import fcj.dntu.vn.backend.utils.GeoUtils;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import org.springframework.http.*;

import java.time.LocalTime;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;

@Service
public class OSMDataServiceImpl {
    private final Logger log = LoggerFactory.getLogger(this.getClass());
    private final String OVERPASS_API_URL = "https://overpass-api.de/api/interpreter";

    private final StopRepository stopRepository;
    private final RouteRepository routeRepository;
    private final WayRepository wayRepository;
    private final WayGeometryRepository wayGeometryRepository;
    private final TimeLineRepository timeLineRepository;

    @PersistenceContext
    private EntityManager entityManager;

    @Autowired
    public OSMDataServiceImpl(RouteRepository routeRepository, StopRepository stopRepository, WayRepository wayRepository, WayGeometryRepository wayGeometryRepository, TimeLineRepository timeLineRepository) {
        this.routeRepository = routeRepository;
        this.stopRepository = stopRepository;
        this.wayRepository = wayRepository;
        this.wayGeometryRepository = wayGeometryRepository;
        this.timeLineRepository = timeLineRepository;
    }

    /*
        fetchData fetches all bus routes in "Binh Duong City"
        then extracts and saves data into the database
     */
    public void fetchData() {
        String queryRelations = """
                [out:json][timeout:25];
                area(id:3601906037)->.searchArea;
                relation["route"="bus"](area.searchArea);
                out geom tags 5;
                """;
        try {
            var response = httpRequest(queryRelations);

            parseAndSave(response.getBody());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void parseAndSave(String response) {
        try {
            JsonNode rootNode = new ObjectMapper().readTree(response);
            JsonNode elements = rootNode.path("elements");

            List<RouteModel> routes = new ArrayList<>();
            List<TimeLineModel> timeLineList = new ArrayList<>();
            for (JsonNode element : elements) {
                // Process route
                RouteModel routeModel = processRoute(element);
                routes.add(routeModel);

                // Process timelines
                List<TimeLineModel> timeLines = processTimeLine(routeModel);
                assert timeLines != null;
                timeLineList.addAll(timeLines);
            }

            routeRepository.saveAll(routes);
            log.info("🚀 Save routes successfully");

            timeLineRepository.saveAll(timeLineList);
            log.info("🚀 Save time lines successfully");

            // process members
            parseAndSaveMembers(routes);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void parseAndSaveMembers(List<RouteModel> routes) {
        try {
            for (RouteModel route : routes) {
                String queryMembers = String.format("""
                    [out:json];
                    rel(%d);
                    nwr(r);
                    out geom tags;
                    """, route.getOsmRelationId());

                var response = httpRequest(queryMembers);

                JsonNode rootNode = new ObjectMapper().readTree(response.getBody());
                JsonNode elements = rootNode.path("elements");

                List<StopModel> stops = new ArrayList<>();
                List<WayModel> ways = new ArrayList<>();
                List<WayGeometryModel> wayGeometries = new ArrayList<>();
                for (int i = 0; i < elements.size(); i++) {
                    JsonNode member = elements.get(i);
                    if ("node".equals(member.get("type").asText())) {
                        StopModel stop = processStop(member, route, i);
                        stops.add(stop);
                    } else if ("way".equals(member.get("type").asText())) {
                        WayModel way = processWay(member, route, i);
                        ways.add(way);
                        for (JsonNode geo : member.get("geometry")) {
                            WayGeometryModel wayGeometry = processWayGeometry(geo, way);
                            wayGeometries.add(wayGeometry);
                        }
                    }
                }

                // Batch save all entities
                wayRepository.saveAll(ways);
                log.info("🚀 Save ways successfully");

                wayGeometryRepository.saveAll(wayGeometries);
                log.info("🚀 Save way geometries successfully");

                stopRepository.saveAll(stops);
                log.info("🚀 Save stops successfully");
            }
            log.info("🚀🚀🚀 Save all data successfully");
        } catch (Exception e) {
            log.error("Error occurred during processing", e);
            e.printStackTrace();
        }
    }

    private ResponseEntity<String> httpRequest(String query) {
        RestTemplate restTemplate = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

        HttpEntity<String> request = new HttpEntity<>("data=" + query, headers);
        return restTemplate.exchange(OVERPASS_API_URL, HttpMethod.POST, request, String.class);
    }

// Helper method for safely parsing values
    String safeParseText(JsonNode node) {
        return node != null ? node.textValue() : null;
    }

    Long safeParseLong(JsonNode node) {
        try {
            return node != null ? Long.parseLong(node.textValue().split("\\s+")[0]) : null;
        } catch (Exception e) {
            return null;
        }
    }

    Integer safeParseInt(JsonNode node) {
        try {
            return node != null ? Integer.parseInt(node.textValue().split("-")[1].split(":")[1]) : null;
        } catch (Exception e) {
            return null;
        }
    }

    LocalTime safeParseLocalTime(JsonNode node, int part) {
        try {
            return node != null ? LocalTime.parse(node.textValue().split("\\s+")[1].split("-")[part]) : null;
        } catch (Exception e) {
            return null;
        }
    }


    private RouteModel processRoute(JsonNode element) {
        try {
            JsonNode tags = element.get("tags");
            return RouteModel.builder().osmRelationId(element.get("id").asLong()).routeName(safeParseText(tags.get("name"))).routePrice(safeParseLong(tags.get("charge"))).routeNumber(tags.get("ref") != null ? tags.get("ref").asText() : null).operator(safeParseText(tags.get("operator"))).intervalMinutes(safeParseInt(tags.get("interval"))).startTime(safeParseLocalTime(tags.get("opening_hours"), 0)).endTime(safeParseLocalTime(tags.get("opening_hours"), 1)).build();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    private List<TimeLineModel> processTimeLine(RouteModel route) {
        try {
            LocalTime startTime = route.getStartTime();
            LocalTime endTime = route.getEndTime();
            int intervalMinutes = route.getIntervalMinutes();
            List<TimeLineModel> timeLines = new ArrayList<>();

            while (startTime.isBefore(endTime)) {
                timeLines.add(TimeLineModel.builder().route(route).departureTime(startTime).build());
                startTime = startTime.plusMinutes(intervalMinutes);
            }

            return timeLines;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }


    private StopModel processStop(JsonNode member, RouteModel route, Integer sequence) {
        try {
            String stopName = member.get("tags").get("name").asText();
            String capitalizedName = stopName.substring(0,1).toUpperCase() + stopName.substring(1);

            StopModel stop = StopModel.builder()
                    .osmNodeId(member.get("id").asLong())
                    .location(GeoUtils.createPoint(member.get("lat").asDouble(), member.get("lon").asDouble()))
                    .route(route)
                    .sequence(sequence)
                    .stopName(capitalizedName)
                    .build();

            return stop;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    private WayModel processWay(JsonNode member, RouteModel routeModel, Integer sequence) {
        try {
            WayModel way = WayModel.builder().sequence(sequence).osmWayId(member.get("id").asLong()).build();

            if (way.getRoutes() == null) {
                way.setRoutes(new HashSet<>());
            }

            way.getRoutes().add(routeModel);

            if (routeModel.getWays() == null) {
                routeModel.setWays(new HashSet<>());
            }

            routeModel.getWays().add(way);

            return way;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    private WayGeometryModel processWayGeometry(JsonNode geo, WayModel way) {
        try {
            return WayGeometryModel.builder().way(way).location(GeoUtils.createPoint(geo.get("lat").asDouble(), geo.get("lon").asDouble())).build();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }

    }
}

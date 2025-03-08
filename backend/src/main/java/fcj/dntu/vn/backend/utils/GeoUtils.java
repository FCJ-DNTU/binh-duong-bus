package fcj.dntu.vn.backend.utils;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import org.locationtech.jts.geom.*;
import org.mapstruct.Named;

import fcj.dntu.vn.backend.dtos.LocationDto;

import java.util.List;

public class GeoUtils {
    private static final GeometryFactory geometryFactory = new GeometryFactory(new PrecisionModel(), 4326);

    public static Point createPoint(double latitude, double longitude) {
        return geometryFactory.createPoint(new Coordinate(longitude, latitude));
    }

    @Named("pointToLocation")
    public static LocationDto pointToLocation(Point point) {
        if (point == null) {
            return null;
        }
        return new LocationDto(point.getY(), point.getX());
    }

    @Named("pointToString")
    public static String pointToString(Point point) {
        if (point == null)
            return "NULL";
        return "Lat: " + point.getY() + ", Lng: " + point.getX();
    }

    @Named("mapLocationDto")
    public static Point locationDtoToPoint(LocationDto locationDto) {
        if (locationDto == null) {
            return null;
        }
        return geometryFactory.createPoint(new Coordinate(locationDto.getLongitude(), locationDto.getLatitude()));
    }

    // Creating rectangular polygon from bounding box
    public static Polygon createBoundingBox(double minLat, double minLon, double maxLat, double maxLon) {
        Coordinate[] coords = new Coordinate[]{
                new Coordinate(minLon, minLat), // Bottom-left
                new Coordinate(maxLon, minLat), // Bottom-right
                new Coordinate(maxLon, maxLat), // Top-right
                new Coordinate(minLon, maxLat), // Top-left
                new Coordinate(minLon, minLat)  // Closing point
        };
        return geometryFactory.createPolygon(geometryFactory.createLinearRing(coords));
    }

    public static LineString createLineString(List<double[]> coordinates) {
        if (coordinates == null || coordinates.size() < 2) {
            throw new IllegalArgumentException("A LineString requires at least 2 points.");
        }

        Coordinate[] coordinateArray = coordinates.stream()
                .map(coord -> new Coordinate(coord[1], coord[0])) // Convert (lat, lon) -> (x, y)
                .toArray(Coordinate[]::new);

        return geometryFactory.createLineString(coordinateArray);
    }

    @Named("lineStringToJsonNode")
    public static JsonNode lineStringToJsonNode(LineString lineString) {
        if (lineString == null) {
            return null;
        }
        try {
            // Get the ObjectMapper
            ObjectMapper objectMapper = new ObjectMapper();

            // Create a GeoJSON structure
            ObjectNode geoJson = objectMapper.createObjectNode();
            geoJson.put("type", "LineString");

            // Convert coordinates
            ArrayNode coordinatesArray = objectMapper.createArrayNode();

            for (Coordinate coord : lineString.getCoordinates()) {
                ArrayNode point = objectMapper.createArrayNode();
                point.add(coord.x);
                point.add(coord.y);
                coordinatesArray.add(point);
            }

            geoJson.set("coordinates", coordinatesArray);
            return geoJson;
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Error converting LineString to JsonNode", e);
        }
    }
    @Named("polygonToJsonNode")
    public static JsonNode polygonToJsonNode(Polygon polygon) {
        if (polygon == null) {
            return null;
        }
        try {
            // Get the ObjectMapper
            ObjectMapper objectMapper = new ObjectMapper();

            // Create a GeoJSON structure
            ObjectNode geoJson = objectMapper.createObjectNode();
            geoJson.put("type", "Polygon");

            // The issue is with how we access coordinates
            // A Polygon has exterior and interior rings
            ArrayNode coordinatesArray = objectMapper.createArrayNode();

            // Add the exterior ring first
            ArrayNode exteriorRingArray = objectMapper.createArrayNode();
            org.locationtech.jts.geom.LineString exteriorRing = polygon.getExteriorRing();

            for (org.locationtech.jts.geom.Coordinate coord : exteriorRing.getCoordinates()) {
                ArrayNode point = objectMapper.createArrayNode();
                point.add(coord.x);
                point.add(coord.y);
                exteriorRingArray.add(point);
            }
            coordinatesArray.add(exteriorRingArray);

            // Add interior rings if any
            for (int i = 0; i < polygon.getNumInteriorRing(); i++) {
                ArrayNode interiorRingArray = objectMapper.createArrayNode();
                org.locationtech.jts.geom.LineString interiorRing = polygon.getInteriorRingN(i);

                for (org.locationtech.jts.geom.Coordinate coord : interiorRing.getCoordinates()) {
                    ArrayNode point = objectMapper.createArrayNode();
                    point.add(coord.x);
                    point.add(coord.y);
                    interiorRingArray.add(point);
                }
                coordinatesArray.add(interiorRingArray);
            }

            geoJson.set("coordinates", coordinatesArray);
            return geoJson;
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Error converting Polygon to JsonNode", e);
        }
    }
}

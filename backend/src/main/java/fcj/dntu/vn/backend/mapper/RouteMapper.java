package fcj.dntu.vn.backend.mapper;

import java.util.Comparator;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Named;
import org.mapstruct.factory.Mappers;

import fcj.dntu.vn.backend.dtos.*;
import fcj.dntu.vn.backend.models.*;
import fcj.dntu.vn.backend.utils.GeoUtils;

@Mapper(componentModel = "spring", uses = { GeoUtils.class })
public interface RouteMapper {
        RouteMapper INSTANCE = Mappers.getMapper(RouteMapper.class);

        @Mapping(target = "buses", source = "buses", qualifiedByName = "mapBuses")
        @Mapping(target = "stops", source = "stops", qualifiedByName = "mapStops")
        @Mapping(target = "timelines", source = "timeLines", qualifiedByName = "mapTimelines")
        @Mapping(target = "ways", source = "ways", qualifiedByName = "mapWays")
        @Mapping(target = "bounds", source = "bounds", qualifiedByName = "polygonToJsonNode")
        RouteDto toRouteDto(RouteModel route);

        List<RouteDto> toRouteDtoList(List<RouteModel> routes);

        List<RouteOnlyDto> toRouteOnlyDtoList(List<RouteModel> routes);

        @Named("mapBuses")
        static List<BusDto> mapBuses(Set<BusModel> buses) {
                return buses == null ? List.of()
                                : buses.stream()
                                                .map(bus -> new BusDto(
                                                                bus.getId(),
                                                                bus.getBusNumber(),
                                                                GeoUtils.pointToLocation(bus.getLocation())))
                                                .collect(Collectors.toList());
        }

        @Named("mapStops")
        static List<StopWithoutRouteIdDto> mapStops(Set<StopModel> stops) {
                return stops == null ? List.of()
                                : stops.stream()
                                                .map(stop -> new StopWithoutRouteIdDto(
                                                                stop.getId(),
                                                                stop.getOsmNodeId(),
                                                                stop.getStopName(),
                                                                GeoUtils.pointToLocation(stop.getLocation()),
                                                                stop.getSequence(),
                                                                stop.getDirection()))
                                                .collect(Collectors.toList());
        }

        @Named("mapTimelines")
        static List<TimelineWithoutRouteId> mapTimelines(Set<TimeLineModel> timeLines) {
                return timeLines == null ? List.of()
                                : timeLines.stream()
                                                .map(timeline -> new TimelineWithoutRouteId(
                                                                timeline.getId(),
                                                                timeline.getDirection(),
                                                                timeline.getDepartureTime()))
                                                .collect(Collectors.toList());
        }

        @Named("mapTimelinesToModel")
        static Set<TimeLineModel> mapTimelinesToModel(List<TimelineWithoutRouteId> timelines) {
                return timelines == null ? Set.of()
                                : timelines.stream()
                                                .map(timeline -> TimeLineModel.builder()
                                                                .id(timeline.getId())
                                                                .direction(timeline.getDirection())
                                                                .departureTime(timeline.getDepartureTime())
                                                                .build())
                                                .collect(Collectors.toSet());
        }

        @Named("mapWays")
        default List<WayDto> mapWays(Set<WayModel> ways) {
                if (ways == null) {
                        return null;
                }
                return ways.stream()
                                .map(way -> WayDto.builder()
                                                .id(way.getId())
                                                .name(way.getName())
                                                .sequence(way.getSequence())
                                                .geometry(GeoUtils.lineStringToJsonNode(way.getGeometry()))
                                                .createdAt(way.getCreatedAt())
                                                .updatedAt(way.getUpdatedAt())
                                                .build())
                                .sorted(Comparator.comparing(WayDto::getSequence))
                                .collect(Collectors.toList());
        }

}
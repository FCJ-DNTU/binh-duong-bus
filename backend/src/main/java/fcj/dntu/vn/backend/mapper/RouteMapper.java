package fcj.dntu.vn.backend.mapper;

import java.awt.*;
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

@Mapper(componentModel = "spring", uses = {GeoUtils.class})
public interface RouteMapper {
    RouteMapper INSTANCE = Mappers.getMapper(RouteMapper.class);

    @Mapping(target = "buses", source = "buses", qualifiedByName = "mapBuses")
    @Mapping(target = "stops", source = "stops", qualifiedByName = "mapStops")
    @Mapping(target = "timelines", source = "timeLines", qualifiedByName = "mapTimelines")
    @Mapping(target = "ways", source = "ways", qualifiedByName = "mapWays")
    RouteDto toRouteDto(RouteModel route);


    List<RouteDto> toRouteDtoList(List<RouteModel> routes);

    List<RouteOnlyDto> toRouteOnlyDtoList(List<RouteModel> routes);

    @Named("mapBuses")
    static List<BusDto> mapBuses(Set<BusModel> buses) {
        return buses == null ? List.of()
                : buses.stream()
                .map(bus ->
                        BusDto.builder()
                                .id(bus.getId())
                                .busNumber(bus.getBusNumber())
                                .location(bus.getLocation())
                                .build())
                .collect(Collectors.toList());
    }

    @Named("mapStops")
    static List<StopDto> mapStops(Set<StopModel> stops) {
        return stops == null ? List.of()
                : stops.stream()
                .map(stop ->
                        StopDto.builder()
                                .id(stop.getId())
                                .stopName(stop.getStopName())
                                .location(stop.getLocation())
                                .sequence(stop.getSequence())
                                .direction(stop.getDirection())
                                .build())
                .collect(Collectors.toList());
    }

    @Named("mapTimelines")
    static List<TimelineDto> mapTimelines(Set<TimeLineModel> timeLines) {
        return timeLines == null ? List.of()
                : timeLines.stream()
                .map(timeline -> TimelineDto.builder()
                        .id(timeline.getId())
                        .direction(timeline.getDirection())
                        .departureTime(timeline.getDepartureTime()).build())
                .collect(Collectors.toList());
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
                        .geometry(way.getGeometry())
                        .createdAt(way.getCreatedAt())
                        .updatedAt(way.getUpdatedAt())
                        .build())
                .collect(Collectors.toList());
    }


}
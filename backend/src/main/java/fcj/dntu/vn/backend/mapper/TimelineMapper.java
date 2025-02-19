package fcj.dntu.vn.backend.mapper;

import java.util.List;
import java.util.UUID;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.Named;

import fcj.dntu.vn.backend.dtos.TimelineDto;
import fcj.dntu.vn.backend.models.RouteModel;
import fcj.dntu.vn.backend.models.TimeLineModel;

@Mapper(componentModel = "spring")
public interface TimelineMapper {
    @Mapping(target = "routeId", source = "route.id")
    TimelineDto toTimelineDto(TimeLineModel timeline);

    List<TimelineDto> toTimelineDtoList(List<TimeLineModel> timelines);

    @Mapping(target = "route", source = "routeId", qualifiedByName = "mapRoute")
    TimeLineModel toTimelineModel(TimelineDto timelineDto);

    List<TimeLineModel> toTimelineModelList(List<TimelineDto> timelineDtos);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "route", ignore = true)
    void updateTimelineFromDto(TimelineDto timelineDto, @MappingTarget TimeLineModel timeline);

    @Named("mapRoute")
    static RouteModel mapRoute(UUID routeId) {
        if (routeId == null)
            return null;
        RouteModel route = new RouteModel();
        route.setId(routeId);
        return route;
    }
}

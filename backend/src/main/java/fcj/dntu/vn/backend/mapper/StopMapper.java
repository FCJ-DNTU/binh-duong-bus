package fcj.dntu.vn.backend.mapper;

import java.util.List;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;

import fcj.dntu.vn.backend.dtos.StopDto;
import fcj.dntu.vn.backend.models.StopModel;
import fcj.dntu.vn.backend.utils.GeoUtils;

@Mapper(componentModel = "spring", uses = { GeoUtils.class })
public interface StopMapper {

    @Mapping(target = "routeId", source = "route.id")
    StopDto toStopDto(StopModel stop);

    List<StopDto> toStopDtoList(List<StopModel> stops);

    StopModel toStopModel(StopDto stopDto);

    List<StopModel> toStopModelList(List<StopDto> stopDtos);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "route", ignore = true)
    void updateStopFromDto(StopDto stopDto, @MappingTarget StopModel stopModel);
}
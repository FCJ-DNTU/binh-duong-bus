package fcj.dntu.vn.backend.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

import fcj.dntu.vn.backend.dtos.BusDto;
import fcj.dntu.vn.backend.models.BusModel;
import fcj.dntu.vn.backend.utils.GeoUtils;

@Mapper(componentModel = "spring", uses = GeoUtils.class)
public interface BusMapper {
    @Mapping(target = "location", source = "location", qualifiedByName = "pointToLocation")
    BusDto toBusDto(BusModel model);

    @Mapping(target = "location", source = "location", qualifiedByName = "mapLocationDto")
    BusModel toBusModel(BusDto dto);
}

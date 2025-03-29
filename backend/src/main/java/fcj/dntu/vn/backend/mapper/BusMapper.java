package fcj.dntu.vn.backend.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

import fcj.dntu.vn.backend.dtos.BusDto;
import fcj.dntu.vn.backend.models.BusModel;
import fcj.dntu.vn.backend.utils.GeoUtils;

@Mapper(componentModel = "spring", uses = GeoUtils.class)
public interface BusMapper {
    BusDto toBusDto(BusModel model);

    BusModel toBusModel(BusDto dto);
}

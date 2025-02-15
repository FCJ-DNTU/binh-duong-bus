package fcj.dntu.vn.backend.dtos;

import java.util.UUID;

import fcj.dntu.vn.backend.models.enums.DirectionEnum;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class StopWithoutRouteIdDto {
    private UUID id;
    private Long osmNodeId;
    private String stopName;
    private LocationDto location;
    private Integer sequence;
    private DirectionEnum direction;

    public StopWithoutRouteIdDto(UUID id, Long osmNodeId, String stopName, LocationDto location, Integer sequence,
            DirectionEnum direction) {
        this.id = id;
        this.osmNodeId = osmNodeId;
        this.stopName = stopName;
        this.location = location;
        this.sequence = sequence;
        this.direction = direction;
    }
}

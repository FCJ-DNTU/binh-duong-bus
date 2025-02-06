package fcj.dntu.vn.backend.dtos;

import java.util.UUID;

import fcj.dntu.vn.backend.models.enums.DirectionEnum;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class StopDto {
    private UUID id;
    private String stopName;
    private LocationDto location;
    private Integer sequence;
    private DirectionEnum direction;
    private UUID routeId;

    public StopDto(UUID id, String stopName, LocationDto location, Integer sequence, DirectionEnum direction,
            UUID routeId) {
        this.id = id;
        this.stopName = stopName;
        this.location = location;
        this.sequence = sequence;
        this.direction = direction;
        this.routeId = routeId;
    }
}

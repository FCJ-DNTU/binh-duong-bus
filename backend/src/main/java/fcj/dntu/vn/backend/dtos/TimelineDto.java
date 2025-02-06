package fcj.dntu.vn.backend.dtos;

import java.time.LocalTime;
import java.util.UUID;

import fcj.dntu.vn.backend.models.enums.DirectionEnum;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class TimelineDto {
    private UUID id;
    private DirectionEnum direction;
    private LocalTime departureTime;
    private UUID routeId;

    public TimelineDto(UUID id, DirectionEnum direction, LocalTime departureTime, UUID routeId) {
        this.id = id;
        this.direction = direction;
        this.departureTime = departureTime;
        this.routeId = routeId;
    }
}

package fcj.dntu.vn.backend.dtos;

import java.time.LocalTime;
import java.util.UUID;

import fcj.dntu.vn.backend.models.enums.DirectionEnum;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class TimelineWithoutRouteId {
    private UUID id;
    private DirectionEnum direction;
    private LocalTime departureTime;

    public TimelineWithoutRouteId(UUID id, DirectionEnum direction, LocalTime departureTime) {
        this.id = id;
        this.direction = direction;
        this.departureTime = departureTime;
    }
}

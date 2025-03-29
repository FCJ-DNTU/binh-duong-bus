package fcj.dntu.vn.backend.dtos;

import java.time.LocalTime;
import java.util.UUID;

import com.fasterxml.jackson.annotation.JsonInclude;
import fcj.dntu.vn.backend.models.enums.DirectionEnum;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
@JsonInclude(JsonInclude.Include.NON_NULL)
public class TimelineDto {
    private UUID id;
    private DirectionEnum direction;
    private LocalTime departureTime;
    private UUID routeId;
}

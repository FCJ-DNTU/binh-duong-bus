package fcj.dntu.vn.backend.dtos;

import java.math.BigDecimal;
import java.time.LocalTime;
import java.util.List;
import java.util.UUID;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.*;
import org.locationtech.jts.geom.Polygon;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@JsonInclude(JsonInclude.Include.NON_NULL)
public class RouteDto {
    private UUID id;
    private Long osmRelationId;
    private String routeNumber;
    private String routeName;
    private LocalTime startTime;
    private LocalTime endTime;
    private Long routePrice;
    private String operator;
    private Integer intervalMinutes;
    private BigDecimal lengthKm;
    private List<BusDto> buses;
    private List<StopDto> stops;
    private List<TimelineDto> timelines;
    private List<WayDto> ways;
    private Polygon bounds;
}

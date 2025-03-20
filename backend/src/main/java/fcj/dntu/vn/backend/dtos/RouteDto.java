package fcj.dntu.vn.backend.dtos;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalTime;
import java.util.List;
import java.util.UUID;

import com.fasterxml.jackson.databind.JsonNode;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RouteDto implements Serializable{
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
    private List<StopWithoutRouteIdDto> stops;
    private List<TimelineWithoutRouteId> timelines;
    private List<WayDto> ways;
    private JsonNode bounds;
}

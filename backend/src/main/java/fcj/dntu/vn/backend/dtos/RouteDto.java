package fcj.dntu.vn.backend.dtos;

import java.math.BigDecimal;
import java.time.LocalTime;
import java.util.List;
import java.util.UUID;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class RouteDto {
    private UUID id;
    private Long osmRelationId;
    private String routeNumber;
    private String routeName;
    private LocalTime startTime;
    private LocalTime endTime;
    private Long routePrice;
    private Integer intervalMinutes;
    private BigDecimal lengthKm;
    private List<BusDto> buses;
    private List<StopWithoutRouteIdDto> stops;
    private List<TimelineWithoutRouteId> timelines;
    private List<WayDto> ways;

    public RouteDto(UUID id, Long osmRelationId, String routeNumber, String routeName, LocalTime startTime,
            LocalTime endTime,
            Long routePrice, Integer intervalMinutes, BigDecimal lengthKm, List<BusDto> buses,
            List<StopWithoutRouteIdDto> stops,
            List<TimelineWithoutRouteId> timelines, List<WayDto> ways) {
        this.id = id;
        this.osmRelationId = osmRelationId;
        this.routeNumber = routeNumber;
        this.routeName = routeName;
        this.startTime = startTime;
        this.endTime = endTime;
        this.routePrice = routePrice;
        this.intervalMinutes = intervalMinutes;
        this.lengthKm = lengthKm;
        this.buses = buses;
        this.stops = stops;
        this.timelines = timelines;
        this.ways = ways;
    }
}

package fcj.dntu.vn.backend.dtos;

import java.math.BigDecimal;
import java.time.LocalTime;
import java.util.UUID;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class RouteOnlyDto {
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

    public RouteOnlyDto(UUID id, Long osmRelationId, String routeNumber, String routeName, LocalTime startTime,
            LocalTime endTime,
            Long routePrice, String operator, Integer intervalMinutes, BigDecimal lengthKm) {
        this.id = id;
        this.osmRelationId = osmRelationId;
        this.routeNumber = routeNumber;
        this.routeName = routeName;
        this.startTime = startTime;
        this.endTime = endTime;
        this.routePrice = routePrice;
        this.operator = operator;
        this.intervalMinutes = intervalMinutes;
        this.lengthKm = lengthKm;
    }
}
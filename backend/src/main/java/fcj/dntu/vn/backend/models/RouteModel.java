package fcj.dntu.vn.backend.models;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.Set;
import java.util.UUID;

@Entity
@Table(name = "routes",
        indexes = {
                @Index(name = "idx_route_name", columnList = "route_name"),
                @Index(name = "idx_route_number", columnList = "route_number")
        })
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RouteModel {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(name = "route_number", length = 20, nullable = false)
    private String routeNumber;

    @Column(name = "route_name", length = 255, nullable = false)
    private String routeName;

    @Column(name = "start_time", nullable = false, length = 20)
    private LocalTime startTime;

    @Column(name = "end_time", nullable = false, length = 20)
    private LocalTime endTime;

    @Column(name = "route_price", nullable = false)
    private Long routePrice;

    @Column(name = "interval_minutes", nullable = false)
    private Integer intervalMinutes;

    @Column(name = "length_km", precision = 5, scale = 2, nullable = false)
    private BigDecimal lengthKm;

    @OneToMany(mappedBy="route", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private Set<BusModel> buses;

    @OneToMany(mappedBy="route", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private Set<StopModel> stops;

    @OneToMany(mappedBy="route", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private Set<TimeLineModel> timeLines;

    @Column(name = "created_at", nullable = false, updatable = false)
    @CreationTimestamp
    private LocalDateTime createdAt;

    @Column(name = "updated_at", nullable = false)
    @UpdateTimestamp
    private LocalDateTime updatedAt;
}

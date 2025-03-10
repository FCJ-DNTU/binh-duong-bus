package fcj.dntu.vn.backend.models;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import org.locationtech.jts.geom.Polygon;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.HashSet;
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

    @Column(name = "osm_relation_id", nullable = false)
    private Long osmRelationId;

    @Column(name = "route_number", length = 20)
    private String routeNumber;

    @Column(name = "route_name", length = 255)
    private String routeName;

    @Column(name = "route_price")
    private Long routePrice;

    @Column(name = "operator")
    private String operator;

    @Column(name = "start_time", length = 20)
    private LocalTime startTime;

    @Column(name = "end_time", length = 20)
    private LocalTime endTime;

    @Column(name = "interval_minutes")
    private Integer intervalMinutes;

    @Column(name = "length_km", precision = 5, scale = 2)
    private BigDecimal lengthKm;

    private Polygon bounds;

    @OneToMany(mappedBy = "route", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private Set<BusModel> buses;

    @OneToMany(mappedBy = "route", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    @OrderBy("createdAt ASC")
    private Set<StopModel> stops;

    @OneToMany(mappedBy = "route", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    @OrderBy("departureTime ASC")
    private Set<TimeLineModel> timeLines = new HashSet<>();

    @ManyToMany(cascade = CascadeType.MERGE)
    @JoinTable(
            name = "routes_ways",
            joinColumns = {@JoinColumn(name = "route_id")},
            inverseJoinColumns = {@JoinColumn(name = "way_id")}
    )
    @OrderBy("createdAt ASC")
    private Set<WayModel> ways = new HashSet<>();

    @Column(name = "created_at", nullable = false, updatable = false)
    @CreationTimestamp
    private LocalDateTime createdAt;

    @Column(name = "updated_at", nullable = false)
    @UpdateTimestamp
    private LocalDateTime updatedAt;
}

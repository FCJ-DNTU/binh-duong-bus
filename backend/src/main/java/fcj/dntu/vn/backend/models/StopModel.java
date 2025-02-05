package fcj.dntu.vn.backend.models;

import fcj.dntu.vn.backend.models.enums.DirectionEnum;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import org.locationtech.jts.geom.Point;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "stops",
        indexes = {
                @Index(name = "idx_route_id", columnList = "route_id"),
                @Index(name = "idx_direction", columnList = "direction"),
                @Index(name = "idx_route_direction_sequence", columnList = "route_id, direction, sequence"),
                @Index(name = "idx_location", columnList = "location", unique = false) // Spatial index (PostGIS)
        })
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class StopModel {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(name = "stop_name", nullable = false)
    private String stopName;

    @Column(columnDefinition = "geometry(Point,4326)")
    private Point location;

    @Column(name = "sequence", nullable = false)
    private Integer sequence; // Defines order in the route

    @Enumerated(EnumType.STRING)
    @Column(name="direction", nullable = false)
    private DirectionEnum direction;

    @ManyToOne
    @JoinColumn(name="route_id", nullable=false)
    private RouteModel route;

    @Column(name = "created_at", nullable = false, updatable = false)
    @CreationTimestamp
    private LocalDateTime createdAt;


    @Column(name = "updated_at", nullable = false)
    @UpdateTimestamp
    private LocalDateTime updatedAt;
}

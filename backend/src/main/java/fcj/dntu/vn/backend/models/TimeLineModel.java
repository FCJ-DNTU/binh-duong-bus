package fcj.dntu.vn.backend.models;

import fcj.dntu.vn.backend.models.enums.DirectionEnum;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.UUID;

@Entity
@Table(name = "time_lines",
        indexes = {
                @Index(name = "idx_departure_time", columnList = "departure_time"),
                @Index(name = "idx_route_direction", columnList = "route_id, direction")
        })
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Builder
public class TimeLineModel {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Enumerated(EnumType.STRING)
    @Column(name = "direction", nullable = false)
    private DirectionEnum direction;

    @Column(name = "departure_time", nullable = false)
    private LocalTime departureTime;

    @ManyToOne
    @JoinColumn(name = "route_id", nullable = false)
    private RouteModel route;

    @Column(name = "created_at", nullable = false, updatable = false)
    @CreationTimestamp
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    @UpdateTimestamp
    private LocalDateTime updatedAt;
}
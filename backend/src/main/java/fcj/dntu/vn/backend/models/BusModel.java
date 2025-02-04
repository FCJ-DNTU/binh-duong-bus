package fcj.dntu.vn.backend.models;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import org.locationtech.jts.geom.Point;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "buses")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class BusModel {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(name = "bus_number", nullable = false)
    private Integer busNumber;

    @Column(columnDefinition = "geometry(Point,4326)")
    private Point location;

    @ManyToOne
    private RouteModel route;

    @Column(name = "created_at", nullable = false, updatable = false)
    @CreationTimestamp
    @Temporal(TemporalType.TIMESTAMP)
    private LocalDateTime createdAt;

    @Column(name = "updated_at", nullable = false)
    @UpdateTimestamp
    @Temporal(TemporalType.TIMESTAMP)
    private LocalDateTime updatedAt;
}

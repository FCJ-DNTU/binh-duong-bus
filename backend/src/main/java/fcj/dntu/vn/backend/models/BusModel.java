package fcj.dntu.vn.backend.models;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import org.locationtech.jts.geom.Point;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "buses", indexes = {
                @Index(name = "idx_route_id", columnList = "route_id"),
                @Index(name = "idx_bus_number", columnList = "bus_number"),
                @Index(name = "idx_location", columnList = "location", unique = false) // Spatial index for geolocation
})
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

        @Column(columnDefinition = "geometry(Point,4326)", nullable = false)
        private Point location;

        @ManyToOne
        @JoinColumn(name = "route_id", nullable = false)
        private RouteModel route;

        @Column(name = "created_at", nullable = false, updatable = false)
        @CreationTimestamp
        private LocalDateTime createdAt;

        @Column(name = "updated_at", nullable = false)
        @UpdateTimestamp
        private LocalDateTime updatedAt;
}

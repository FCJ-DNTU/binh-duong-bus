package fcj.dntu.vn.backend.models;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import org.locationtech.jts.geom.Point;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "stops")
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

    @ManyToOne
    private RouteModel route;

//    private Integer sequence;

    @Column(name = "created_at", nullable = false, updatable = false)
    @CreationTimestamp
    private LocalDateTime createdAt;


    @Column(name = "updated_at", nullable = false)
    @UpdateTimestamp
    private LocalDateTime updatedAt;
}

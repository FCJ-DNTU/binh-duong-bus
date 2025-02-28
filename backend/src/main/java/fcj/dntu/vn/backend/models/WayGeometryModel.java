package fcj.dntu.vn.backend.models;

import lombok.*;
import jakarta.persistence.*;
import org.locationtech.jts.geom.Point;

import java.util.UUID;

@Entity
@Table(name = "way_geometry")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class WayGeometryModel {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(columnDefinition = "geometry(Point,4326)")
    private Point location;

    @ManyToOne
    @JoinColumn(name = "way_id", nullable = false)
    private WayModel way;
}

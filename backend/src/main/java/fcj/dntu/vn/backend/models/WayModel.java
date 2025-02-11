package fcj.dntu.vn.backend.models;

import lombok.*;
import jakarta.persistence.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.UUID;

@Entity
@Table(name = "ways")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class WayModel {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(name="osm_way_id", nullable=false, unique=true)
    private Long osmWayId;

    private String name;

    private Integer sequence;

    @OneToMany(mappedBy = "way", cascade = CascadeType.ALL)
    private List<WayGeometryModel> geometries;

    @ManyToMany(mappedBy = "ways")
    @Builder.Default
    private Set<RouteModel> routes = new HashSet<>();

    @Column(name = "created_at", nullable = false, updatable = false)
    @CreationTimestamp
    private LocalDateTime createdAt;

    @Column(name = "updated_at", nullable = false)
    @UpdateTimestamp
    private LocalDateTime updatedAt;
}

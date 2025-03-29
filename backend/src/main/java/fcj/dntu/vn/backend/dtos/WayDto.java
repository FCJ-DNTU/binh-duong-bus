package fcj.dntu.vn.backend.dtos;

import java.time.LocalDateTime;
import java.util.UUID;

import lombok.*;
import org.locationtech.jts.geom.LineString;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class WayDto {
    private UUID id;
    // osmWayId is explicitly excluded as requested
    private String name;
    private Integer sequence;
    private LineString geometry;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}

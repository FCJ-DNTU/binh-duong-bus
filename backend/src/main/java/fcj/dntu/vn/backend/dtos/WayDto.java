package fcj.dntu.vn.backend.dtos;

import java.time.LocalDateTime;
import java.util.UUID;

import com.fasterxml.jackson.databind.JsonNode;
import lombok.*;

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
    private JsonNode geometry; // LineString as GeoJSON
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}

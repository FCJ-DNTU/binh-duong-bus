package fcj.dntu.vn.backend.dtos;

import java.awt.*;
import java.util.UUID;

import com.fasterxml.jackson.annotation.JsonInclude;
import fcj.dntu.vn.backend.models.enums.DirectionEnum;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import org.locationtech.jts.geom.Point;

@Getter
@Setter
@Builder
@JsonInclude(JsonInclude.Include.NON_NULL)
public class StopDto {
    private UUID id;
    private String stopName;
    private Point location;
    private Integer sequence;
    private DirectionEnum direction;
    private UUID routeId;
}

package fcj.dntu.vn.backend.dtos;

import java.util.UUID;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import org.locationtech.jts.geom.Point;

@Getter
@Setter
@Builder
public class BusDto {
    private UUID id;
    private int busNumber;
    private Point location;
}

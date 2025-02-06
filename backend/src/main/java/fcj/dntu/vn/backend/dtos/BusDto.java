package fcj.dntu.vn.backend.dtos;

import java.util.UUID;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class BusDto {
    private UUID id;
    private int busNumber;
    private LocationDto location;

    public BusDto(UUID id, int busNumber, LocationDto location) {
        this.id = id;
        this.busNumber = busNumber;
        this.location = location;
    }
}

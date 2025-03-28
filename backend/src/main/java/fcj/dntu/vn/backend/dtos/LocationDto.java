package fcj.dntu.vn.backend.dtos;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class LocationDto {
    private double latitude;
    private double longitude;

    public LocationDto(double latitude, double longitude) {
        this.latitude = latitude;
        this.longitude = longitude;
    }

    public double getLatitude() {
        return latitude;
    }

    public void setLatitude(double latitude) {
        this.latitude = latitude;
    }

    public double getLongitude() {
        return longitude;
    }

    public void setLongitude(double longitude) {
        this.longitude = longitude;
    }
}

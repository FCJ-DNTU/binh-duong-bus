package fcj.dntu.vn.backend.utils;

import org.junit.jupiter.api.Test;
import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.geom.Point;
import static org.assertj.core.api.Assertions.assertThat;

class GeoUtilsTest {

    private static final GeometryFactory geometryFactory = new GeometryFactory();

    @Test
    void createPoint_ShouldReturnValidPoint() {
        // Given
        double latitude = 10.775;
        double longitude = 106.698;

        // When
        Point point = GeoUtils.createPoint(latitude, longitude);

        // Then
        assertThat(point).isNotNull();
        assertThat(point.getX()).isEqualTo(longitude); // X = Longitude
        assertThat(point.getY()).isEqualTo(latitude);  // Y = Latitude
    }

    @Test
    void pointToString_ShouldReturnFormattedString() {
        // Given
        Point point = geometryFactory.createPoint(new Coordinate(106.698, 10.775));

        // When
        String result = GeoUtils.pointToString(point);

        // Then
        assertThat(result).isEqualTo("Lat: 10.775, Lng: 106.698");
    }

    @Test
    void pointToString_ShouldReturnNullForNullPoint() {
        // When
        String result = GeoUtils.pointToString(null);

        // Then
        assertThat(result).isEqualTo("NULL");
    }
}

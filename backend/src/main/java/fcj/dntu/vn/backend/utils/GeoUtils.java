package fcj.dntu.vn.backend.utils;

import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.geom.Point;
import org.locationtech.jts.geom.PrecisionModel;

import fcj.dntu.vn.backend.dtos.LocationDto;

public class GeoUtils {
    private static final GeometryFactory geometryFactory = new GeometryFactory(new PrecisionModel(), 4326);

    public static Point createPoint(double latitude, double longitude) {
        return geometryFactory.createPoint(new Coordinate(longitude, latitude));
    }

    public static LocationDto pointToLocation(Point point) {
        if (point == null) {
            return null;
        }
        return new LocationDto(point.getY(), point.getX());
    }

    public static String pointToString(Point point) {
        if (point == null)
            return "NULL";
        return "Lat: " + point.getY() + ", Lng: " + point.getX();
    }

    public static Point locationDtoToPoint(LocationDto locationDto) {
        if (locationDto == null) {
            throw new IllegalArgumentException("LocationDto is null");
        }

        double latitude = locationDto.getLatitude();
        double longitude = locationDto.getLongitude();

        return createPoint(latitude, longitude);
    }

}

package fcj.dntu.vn.backend.utils;

import org.locationtech.jts.geom.*;
import org.mapstruct.Named;

import fcj.dntu.vn.backend.dtos.LocationDto;

public class GeoUtils {
    private static final GeometryFactory geometryFactory = new GeometryFactory(new PrecisionModel(), 4326);

    public static Point createPoint(double latitude, double longitude) {
        return geometryFactory.createPoint(new Coordinate(longitude, latitude));
    }

    @Named("pointToLocation")
    public static LocationDto pointToLocation(Point point) {
        if (point == null) {
            return null;
        }
        return new LocationDto(point.getY(), point.getX());
    }

    @Named("pointToString")
    public static String pointToString(Point point) {
        if (point == null)
            return "NULL";
        return "Lat: " + point.getY() + ", Lng: " + point.getX();
    }

    @Named("mapLocationDto")
    public static Point locationDtoToPoint(LocationDto locationDto) {
        if (locationDto == null) {
            return null;
        }
        return geometryFactory.createPoint(new Coordinate(locationDto.getLongitude(), locationDto.getLatitude()));
    }
}

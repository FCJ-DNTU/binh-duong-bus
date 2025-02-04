package fcj.dntu.vn.backend.utils;

import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.geom.Point;
import org.locationtech.jts.geom.PrecisionModel;

public class GeoUtils {
    private static final GeometryFactory geometryFactory = new GeometryFactory(new PrecisionModel(), 4326);

    public static Point createPoint(double latitude, double longitude) {
        return geometryFactory.createPoint(new Coordinate(longitude, latitude));
    }

    public static String pointToString(Point point) {
        if (point == null) return "NULL";
        return "Lat: " + point.getY() + ", Lng: " + point.getX();
    }
}

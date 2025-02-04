package fcj.dntu.vn.backend;

import fcj.dntu.vn.backend.models.BusModel;
import fcj.dntu.vn.backend.models.RouteModel;
import fcj.dntu.vn.backend.models.StopModel;
import fcj.dntu.vn.backend.repositories.BusRepository;
import fcj.dntu.vn.backend.repositories.RouteRepository;
import fcj.dntu.vn.backend.repositories.StopRepository;
import fcj.dntu.vn.backend.utils.GeoUtils;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import java.math.BigDecimal;

@Component
@RequiredArgsConstructor
public class DataSeeder {

    private final BusRepository busRepository;
    private final RouteRepository routeRepository;
    private final StopRepository stopRepository;

    @PostConstruct
    public void seedData() {
        if (routeRepository.count() > 0) return; // Prevent duplicate seeding

        // Create Routes
        RouteModel route1 = RouteModel.builder()
                .routeNumber("R001")
                .routeName("Main Street Route")
                .startTime("06:00")
                .endTime("22:00")
                .routePrice(BigDecimal.valueOf(15.50))
                .intervalMinutes(30)
                .lengthKm(BigDecimal.valueOf(12.5))
                .build();

        RouteModel route2 = RouteModel.builder()
                .routeNumber("R002")
                .routeName("Downtown Express")
                .startTime("05:30")
                .endTime("23:00")
                .routePrice(BigDecimal.valueOf(20.00))
                .intervalMinutes(20)
                .lengthKm(BigDecimal.valueOf(8.2))
                .build();

        routeRepository.save(route1);
        routeRepository.save(route2);

        // Create Stops
        StopModel stop1 = StopModel.builder()

                .stopName("Stop A")
                .location(GeoUtils.createPoint(10.775, 106.698))
                .route(route1)
                .build();

        StopModel stop2 = StopModel.builder()
                .stopName("Stop B")
                .location(GeoUtils.createPoint(10.780, 106.690))
                .route(route1)
                .build();

        stopRepository.save(stop1);
        stopRepository.save(stop2);

        // Create Buses
        BusModel bus1 = BusModel.builder()
                .busNumber(101)
                .location(GeoUtils.createPoint(10.775, 106.698))
                .route(route1)
                .build();

        BusModel bus2 = BusModel.builder()
                .busNumber(102)
                .location(GeoUtils.createPoint(10.780, 106.690))
                .route(route2)
                .build();

        busRepository.save(bus1);
        busRepository.save(bus2);

        System.out.println("🚀 Database seeded successfully!");
    }
}

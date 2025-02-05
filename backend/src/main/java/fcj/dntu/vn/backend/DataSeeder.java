package fcj.dntu.vn.backend;

import fcj.dntu.vn.backend.models.BusModel;
import fcj.dntu.vn.backend.models.RouteModel;
import fcj.dntu.vn.backend.models.StopModel;
import fcj.dntu.vn.backend.models.TimeLineModel;
import fcj.dntu.vn.backend.models.enums.DirectionEnum;
import fcj.dntu.vn.backend.repositories.BusRepository;
import fcj.dntu.vn.backend.repositories.RouteRepository;
import fcj.dntu.vn.backend.repositories.StopRepository;
import fcj.dntu.vn.backend.repositories.TimeLineRepository;
import fcj.dntu.vn.backend.utils.GeoUtils;
import jakarta.annotation.PostConstruct;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

@Component
@RequiredArgsConstructor
public class DataSeeder {

    private final BusRepository busRepository;
    private final RouteRepository routeRepository;
    private final StopRepository stopRepository;
    private final TimeLineRepository timeLineRepository;

    @PostConstruct
    @Transactional
    public void seedData() {
        if (routeRepository.count() > 0) return; // Prevent duplicate seeding

        // Create Routes
        RouteModel route1 = routeRepository.save(
                RouteModel.builder()
                        .routeNumber("R001")
                        .routeName("Main Street Route")
                        .startTime(LocalTime.of(6,0))
                        .endTime(LocalTime.of(22,0))
                        .routePrice(29999L)
                        .intervalMinutes(30)
                        .lengthKm(BigDecimal.valueOf(12.5))
                        .build()
        );

        RouteModel route2 = routeRepository.save(
                RouteModel.builder()
                        .routeNumber("R002")
                        .routeName("Downtown Express")
                        .startTime(LocalTime.of(5,30))
                        .endTime(LocalTime.of(21,0))
                        .routePrice(10000L)
                        .intervalMinutes(20)
                        .lengthKm(BigDecimal.valueOf(8.2))
                        .build()
        );

        // Create Stops
        stopRepository.saveAll(List.of(
                StopModel.builder().stopName("Stop A").location(GeoUtils.createPoint(10.775, 106.698)).route(route1).direction(DirectionEnum.INBOUND).sequence(1).build(),
                StopModel.builder().stopName("Stop B").location(GeoUtils.createPoint(10.780, 106.690)).route(route1).direction(DirectionEnum.INBOUND).sequence(2).build()
        ));

        // Create Buses
        busRepository.saveAll(List.of(
                BusModel.builder().busNumber(101).location(GeoUtils.createPoint(10.775, 106.698)).route(route1).build(),
                BusModel.builder().busNumber(102).location(GeoUtils.createPoint(10.780, 106.690)).route(route2).build()
        ));

        // Generate multiple timeline entries for route1
        List<TimeLineModel> timelines = new ArrayList<>();
        LocalTime currentTime = LocalTime.of(6, 0); // Start at 6:00 AM
        LocalTime endTime = LocalTime.of(6, 30); // End at 7:00 PM

        while (currentTime.isBefore(endTime)) {
            timelines.add(TimeLineModel.builder()
                    .route(route1)
                    .direction(DirectionEnum.OUTBOUND)
                    .departureTime(currentTime)
                    .build());

            timelines.add(TimeLineModel.builder()
                    .route(route1)
                    .direction(DirectionEnum.INBOUND)
                    .departureTime(currentTime.plusMinutes(route1.getIntervalMinutes()))
                    .build());

            currentTime = currentTime.plusMinutes(route1.getIntervalMinutes());
        }

        timeLineRepository.saveAll(timelines);

        System.out.println("🚀 Database seeded successfully!");
    }

}

package fcj.dntu.vn.backend.services.impl;

import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import fcj.dntu.vn.backend.dtos.*;
import fcj.dntu.vn.backend.exceptions.RouteNotFound;
import fcj.dntu.vn.backend.exceptions.responses.ApiResponse;
import fcj.dntu.vn.backend.models.*;
import fcj.dntu.vn.backend.models.enums.DirectionEnum;
import fcj.dntu.vn.backend.repositories.*;
import fcj.dntu.vn.backend.services.RouteService;
import fcj.dntu.vn.backend.utils.GeoUtils;

@Service
public class RouteServiceImpl implements RouteService {

        @Autowired
        private RouteRepository routeRepository;

        @Autowired
        private StopRepository stopRepository;

        @Autowired
        private TimeLineRepository timeLineRepository;

        @Override
        public ResponseEntity<ApiResponse<List<RouteDto>>> getAllRoutes() {
                List<RouteModel> routes = routeRepository.findAll();
                if (routes.isEmpty()) {
                        throw new RouteNotFound("Không có tuyến xe nào trong hệ thống");
                }

                List<RouteDto> routeDtos = routes.stream().map(route -> new RouteDto(
                                route.getId(), route.getRouteNumber(), route.getRouteName(), route.getStartTime(),
                                route.getEndTime(), route.getRoutePrice(), route.getIntervalMinutes(),
                                route.getLengthKm(),
                                route.getBuses().stream().map(bus -> new BusDto(
                                                bus.getId(),
                                                bus.getBusNumber(),
                                                GeoUtils.pointToLocation(bus.getLocation()))).toList()))
                                .toList();

                return ResponseEntity.ok(new ApiResponse<>("Danh sách tuyến đường", routeDtos));
        }

        @Override
        public ResponseEntity<ApiResponse<RouteDto>> getRouteById(UUID id) {
                RouteModel route = routeRepository.findById(id)
                                .orElseThrow(() -> new RouteNotFound("Tuyến đường với ID " + id + " không tồn tại"));

                List<BusDto> busDtos = route.getBuses().stream().map(bus -> new BusDto(
                                bus.getId(),
                                bus.getBusNumber(),
                                GeoUtils.pointToLocation(bus.getLocation()))).toList();

                RouteDto routeDto = new RouteDto(route.getId(), route.getRouteNumber(), route.getRouteName(),
                                route.getStartTime(), route.getEndTime(), route.getRoutePrice(),
                                route.getIntervalMinutes(),
                                route.getLengthKm(), busDtos);

                return ResponseEntity.ok(new ApiResponse<>("Thông tin tuyến đường", routeDto));
        }

        @Override
        public ResponseEntity<?> addRoute(RouteModel route) {
                RouteModel savedRoute = routeRepository.save(route);

                List<BusDto> busDtos = savedRoute.getBuses() != null
                                ? savedRoute.getBuses().stream().map(bus -> new BusDto(
                                                bus.getId(),
                                                bus.getBusNumber(),
                                                GeoUtils.pointToLocation(bus.getLocation()))).toList()
                                : List.of();

                RouteDto responseDto = new RouteDto(savedRoute.getId(), savedRoute.getRouteNumber(),
                                savedRoute.getRouteName(),
                                savedRoute.getStartTime(), savedRoute.getEndTime(), savedRoute.getRoutePrice(),
                                savedRoute.getIntervalMinutes(), savedRoute.getLengthKm(), busDtos);

                return ResponseEntity.status(HttpStatus.CREATED).body(
                                new ApiResponse<>("Tuyến đường đã được thêm thành công!", responseDto));
        }

        @Override
        public ResponseEntity<?> updateRoute(UUID id, RouteModel updatedRoute) {
                RouteModel existingRoute = routeRepository.findById(id)
                                .orElseThrow(() -> new RouteNotFound("Tuyến đường với ID " + id + " không tồn tại"));

                // update
                existingRoute.setRouteNumber(updatedRoute.getRouteNumber());
                existingRoute.setRouteName(updatedRoute.getRouteName());
                existingRoute.setStartTime(updatedRoute.getStartTime());
                existingRoute.setEndTime(updatedRoute.getEndTime());
                existingRoute.setRoutePrice(updatedRoute.getRoutePrice());
                existingRoute.setIntervalMinutes(updatedRoute.getIntervalMinutes());
                existingRoute.setLengthKm(updatedRoute.getLengthKm());
                existingRoute.setIntervalMinutes(updatedRoute.getIntervalMinutes());

                // if the relationship has any update, change it here
                if (updatedRoute.getBuses() != null) {
                        existingRoute.setBuses(updatedRoute.getBuses());
                }
                if (updatedRoute.getStops() != null) {
                        existingRoute.setStops(updatedRoute.getStops());
                }
                if (updatedRoute.getTimeLines() != null) {
                        existingRoute.setTimeLines(updatedRoute.getTimeLines());
                }

                // save
                RouteModel savedRoute = routeRepository.save(existingRoute);

                // transfer to dtoo to response
                List<BusDto> busDtos = savedRoute.getBuses().stream().map(bus -> new BusDto(
                                bus.getId(),
                                bus.getBusNumber(),
                                GeoUtils.pointToLocation(bus.getLocation()))).toList();

                RouteDto responseDto = new RouteDto(savedRoute.getId(), savedRoute.getRouteNumber(),
                                savedRoute.getRouteName(),
                                savedRoute.getStartTime(), savedRoute.getEndTime(), savedRoute.getRoutePrice(),
                                savedRoute.getIntervalMinutes(), savedRoute.getLengthKm(), busDtos);

                return ResponseEntity.ok(new ApiResponse<>("Tuyến đường đã được cập nhật thành công!", responseDto));
        }

        @Override
        public ResponseEntity<?> deleteRoute(UUID id) {
                RouteModel existingRoute = routeRepository.findById(id)
                                .orElseThrow(() -> new RouteNotFound("Tuyến đường với ID " + id + " không tồn tại"));

                routeRepository.delete(existingRoute);

                return ResponseEntity.ok(new ApiResponse<>("Tuyến đường đã bị xóa thành công!", null));
        }

        @Override
        public ResponseEntity<ApiResponse<List<StopDto>>> getRouteStops(UUID routeId, String direction) {
                RouteModel route = routeRepository.findById(routeId)
                                .orElseThrow(() -> new RouteNotFound("Tuyến xe không tồn tại"));

                List<StopModel> stops;

                if (direction != null) {
                        stops = stopRepository.findByRouteIdAndDirection(routeId,
                                        DirectionEnum.valueOf(direction.toUpperCase()));
                } else {
                        stops = stopRepository.findByRouteId(routeId);
                }

                if (stops.isEmpty()) {
                        return ResponseEntity.ok(new ApiResponse<>("Danh sách các điểm dừng của tuyến", List.of()));
                }

                List<StopDto> stopDtos = stops.stream()
                                .map(stop -> new StopDto(
                                                stop.getId(),
                                                stop.getStopName(),
                                                GeoUtils.pointToLocation(stop.getLocation()),
                                                stop.getSequence(),
                                                stop.getDirection(),
                                                stop.getRoute().getId()))
                                .toList();

                return ResponseEntity.ok(new ApiResponse<>("Danh sách các điểm dừng của tuyến", stopDtos));
        }

        @Override
        public ResponseEntity<ApiResponse<List<TimelineDto>>> getRouteTimelines(UUID routeId, String direction) {
                RouteModel route = routeRepository.findById(routeId)
                                .orElseThrow(() -> new RouteNotFound("Tuyến xe với ID " + routeId + " không tồn tại"));

                List<TimeLineModel> timeLines;

                if (direction != null && !direction.isEmpty()) {
                        DirectionEnum directionEnum;
                        try {
                                directionEnum = DirectionEnum.valueOf(direction.toUpperCase());
                        } catch (IllegalArgumentException e) {
                                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                                                .body(new ApiResponse<>("Invalid direction value: " + direction, null));
                        }

                        timeLines = timeLineRepository.findByRouteIdAndDirection(routeId, directionEnum);
                } else {
                        timeLines = timeLineRepository.findByRouteId(routeId);
                }

                if (timeLines.isEmpty()) {
                        return ResponseEntity
                                        .ok(new ApiResponse<>("Danh sách thời gian khởi hành của tuyến", List.of()));
                }

                List<TimelineDto> timeLineDtos = timeLines.stream()
                                .map(timeLine -> {
                                        RouteDto routeDto = new RouteDto(
                                                        timeLine.getRoute().getId(),
                                                        timeLine.getRoute().getRouteNumber(),
                                                        timeLine.getRoute().getRouteName(),
                                                        timeLine.getRoute().getStartTime(),
                                                        timeLine.getRoute().getEndTime(),
                                                        timeLine.getRoute().getRoutePrice(),
                                                        timeLine.getRoute().getIntervalMinutes(),
                                                        timeLine.getRoute().getLengthKm(),
                                                        timeLine.getRoute().getBuses().stream()
                                                                        .map(bus -> new BusDto(bus.getId(),
                                                                                        bus.getBusNumber(),
                                                                                        GeoUtils.pointToLocation(bus
                                                                                                        .getLocation())))
                                                                        .toList());

                                        return new TimelineDto(
                                                        timeLine.getId(),
                                                        timeLine.getDirection(),
                                                        timeLine.getDepartureTime(),
                                                        timeLine.getRoute().getId());
                                })
                                .toList();

                return ResponseEntity.ok(new ApiResponse<>("Danh sách thời gian khởi hành của tuyến", timeLineDtos));
        }

        @Override
        public ResponseEntity<ApiResponse<List<RouteDto>>> getRouteByRouteName(String routeName) {
                List<RouteModel> routes = routeRepository.findByRouteName(routeName);

                if (routes.isEmpty()) {
                        return ResponseEntity.status(HttpStatus.NOT_FOUND)
                                        .body(new ApiResponse<>("Không tìm thấy tuyến đường có tên: " + routeName,
                                                        List.of()));
                }

                List<RouteDto> routeDtos = routes.stream().map(route -> {
                        List<BusDto> busDtos = route.getBuses().stream().map(bus -> new BusDto(
                                        bus.getId(),
                                        bus.getBusNumber(),
                                        GeoUtils.pointToLocation(bus.getLocation()))).toList();

                        return new RouteDto(route.getId(), route.getRouteNumber(), route.getRouteName(),
                                        route.getStartTime(),
                                        route.getEndTime(), route.getRoutePrice(), route.getIntervalMinutes(),
                                        route.getLengthKm(),
                                        busDtos);
                }).toList();

                return ResponseEntity.ok(new ApiResponse<>("Danh sách tuyến đường", routeDtos));
        }
}

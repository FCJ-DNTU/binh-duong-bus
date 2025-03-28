package fcj.dntu.vn.backend.services.impl;

import java.util.List;
import java.util.UUID;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import fcj.dntu.vn.backend.dtos.*;
import fcj.dntu.vn.backend.exceptions.RouteNotFound;
import fcj.dntu.vn.backend.exceptions.responses.ApiResponse;
import fcj.dntu.vn.backend.mapper.RouteMapper;
import fcj.dntu.vn.backend.mapper.StopMapper;
import fcj.dntu.vn.backend.mapper.TimelineMapper;
import fcj.dntu.vn.backend.models.*;
import fcj.dntu.vn.backend.models.enums.DirectionEnum;
import fcj.dntu.vn.backend.repositories.*;
import fcj.dntu.vn.backend.services.RouteService;
import jakarta.transaction.Transactional;

@Service
public class RouteServiceImpl implements RouteService {

    private final RouteRepository routeRepository;
    private final StopRepository stopRepository;
    private final TimeLineRepository timeLineRepository;
    private final RouteMapper routeMapper;
    private final StopMapper stopMapper;
    private final TimelineMapper timelineMapper;

    public RouteServiceImpl(RouteRepository routeRepository, StopRepository stopRepository,
                            TimeLineRepository timeLineRepository, RouteMapper routeMapper, StopMapper stopMapper,
                            TimelineMapper timelineMapper) {
        this.routeRepository = routeRepository;
        this.stopRepository = stopRepository;
        this.timeLineRepository = timeLineRepository;
        this.routeMapper = routeMapper;
        this.stopMapper = stopMapper;
        this.timelineMapper = timelineMapper;
    }

    @Override
    public ResponseEntity<ApiResponse<List<RouteOnlyDto>>> getAllRoutes() {
        List<RouteModel> routes = routeRepository.findAll();
        if (routes.isEmpty()) {
            throw new RouteNotFound("Không có tuyến xe nào trong hệ thống");
        }

        List<RouteOnlyDto> routeDtos = routeMapper.toRouteOnlyDtoList(routes);

        return ResponseEntity.ok(new ApiResponse<>("Danh sách tuyến đường", routeDtos));
    }

    @Override
    public ResponseEntity<ApiResponse<RouteDto>> getRouteById(UUID id) {
        RouteDto routeDto = routeRepository.findByIdWithAllRelations(id)
                .map(routeMapper::toRouteDto)
                .orElseThrow(() -> new RouteNotFound("Tuyến đường với ID " + id + " không tồn tại"));

        return ResponseEntity.ok(new ApiResponse<>("Thông tin tuyến đường", routeDto));
    }

    @Override
    public ResponseEntity<?> addRoute(RouteModel route) {
        RouteModel savedRoute = routeRepository.save(route);
        RouteDto responseDto = routeMapper.toRouteDto(savedRoute);

        return ResponseEntity.status(HttpStatus.CREATED).body(
                new ApiResponse<>("Tuyến đường đã được thêm thành công!", responseDto));
    }

    @Transactional
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

        // save db
        RouteModel savedRoute = routeRepository.save(existingRoute);
        // return dto
        RouteDto responseDto = routeMapper.toRouteDto(savedRoute);

        return ResponseEntity.ok(new ApiResponse<>("Tuyến đường đã được cập nhật thành công!", responseDto));
    }

    @Override
    public ResponseEntity<?> deleteRoute(UUID id) {
        RouteModel existingRoute = routeRepository.findById(id)
                .orElseThrow(() -> new RouteNotFound("Tuyến đường với ID " + id + " không tồn tại"));

        // delete relation before delete route
        stopRepository.deleteByRouteId(id);
        timeLineRepository.deleteByRouteId(id);

        routeRepository.delete(existingRoute);

        return ResponseEntity.ok(new ApiResponse<>("Tuyến đường đã bị xóa thành công!", null));
    }

    @Override
    public ResponseEntity<ApiResponse<List<StopDto>>> getRouteStops(UUID routeId, String direction) {
        routeRepository.findById(routeId)
                .orElseThrow(() -> new RouteNotFound("Tuyến xe không tồn tại"));

        List<StopModel> stops;

        if (direction != null && !direction.isEmpty()) {
            try {
                DirectionEnum directionEnum = DirectionEnum.valueOf(direction.toUpperCase());
                stops = stopRepository.findByRouteIdAndDirection(routeId, directionEnum);
            } catch (IllegalArgumentException e) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                        .body(new ApiResponse<>("Direction không hợp lệ: " + direction,
                                List.of()));
            }
        } else {
            stops = stopRepository.findByRouteId(routeId);
        }

        List<StopDto> stopDtos = stopMapper.toStopDtoList(stops);

        return ResponseEntity.ok(new ApiResponse<>("Danh sách các điểm dừng của tuyến", stopDtos));
    }

    @Override
    public ResponseEntity<ApiResponse<List<TimelineDto>>> getRouteTimelines(UUID routeId, String direction) {
        routeRepository.findById(routeId)
                .orElseThrow(() -> new RouteNotFound("Tuyến xe với ID " + routeId + " không tồn tại"));

        List<TimeLineModel> timeLines;

        if (direction != null && !direction.isEmpty()) {
            try {
                DirectionEnum directionEnum = DirectionEnum.valueOf(direction.toUpperCase());
                timeLines = timeLineRepository.findByRouteIdAndDirection(routeId, directionEnum);
            } catch (IllegalArgumentException e) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                        .body(new ApiResponse<>("Direction không hợp lệ: " + direction,
                                List.of()));
            }
        } else {
            timeLines = timeLineRepository.findByRouteId(routeId);
        }

        List<TimelineDto> timeLineDtos = timelineMapper.toTimelineDtoList(timeLines);

        return ResponseEntity.ok(new ApiResponse<>("Danh sách thời gian khởi hành của tuyến", timeLineDtos));
    }

    @Override
    public ResponseEntity<ApiResponse<List<RouteDto>>> getRouteByRouteName(String routeName) {
        List<RouteModel> routes = routeRepository.findByRouteNameWithAllRelations(routeName);

        if (routes.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(new ApiResponse<>("Không tìm thấy tuyến đường có tên: " + routeName,
                            List.of()));
        }

        List<RouteDto> routeDtos = routeMapper.toRouteDtoList(routes);

        return ResponseEntity.ok(new ApiResponse<>("Danh sách tuyến đường", routeDtos));
    }

    @Override
    public ResponseEntity<ApiResponse<RouteDto>> getReturnRoute(UUID routeId) {
        RouteModel currentRoute = routeRepository.findById(routeId)
                .orElseThrow(() -> new RouteNotFound(
                        "Tuyến đường với ID " + routeId + " không tồn tại"));

        List<RouteModel> matchingRoutes = routeRepository.findByRouteNumber(currentRoute.getRouteNumber());

        // get route which has the same route number except the current route
        RouteModel returnRoute = matchingRoutes.stream()
                .filter(route -> !route.getId().equals(routeId))
                .findFirst()
                .orElseThrow(() -> new RouteNotFound("Không tìm thấy tuyến lượt về cho tuyến này"));

        RouteDto returnRouteDto = routeMapper.toRouteDto(returnRoute);

        return ResponseEntity.ok(new ApiResponse<>("Thông tin tuyến lượt về", returnRouteDto));
    }
}
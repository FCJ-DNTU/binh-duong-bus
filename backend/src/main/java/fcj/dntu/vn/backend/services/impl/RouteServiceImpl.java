package fcj.dntu.vn.backend.services.impl;

import java.util.List;
import java.util.UUID;

import org.springframework.cache.CacheManager;
import org.springframework.cache.annotation.Cacheable;
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
    private final CacheManager cacheManager;

    public RouteServiceImpl(RouteRepository routeRepository, StopRepository stopRepository,
            TimeLineRepository timeLineRepository, RouteMapper routeMapper, StopMapper stopMapper,
            TimelineMapper timelineMapper, CacheManager cacheManager) {
        this.routeRepository = routeRepository;
        this.stopRepository = stopRepository;
        this.timeLineRepository = timeLineRepository;
        this.routeMapper = routeMapper;
        this.stopMapper = stopMapper;
        this.timelineMapper = timelineMapper;
        this.cacheManager = cacheManager;
    }

    public void clearCache() {
        cacheManager.getCache("routes").clear();
        cacheManager.getCache("route").clear();
    }

    @Override
    @Cacheable(value = "routes", key = "'all_routes'")
    public List<RouteOnlyDto> getAllRoutesData() {
        List<RouteModel> routes = routeRepository.findAll();
        if (routes.isEmpty()) {
            throw new RouteNotFound("Không có tuyến xe nào trong hệ thống");
        }
        return routeMapper.toRouteOnlyDtoList(routes);
    }

    @Override
    public ResponseEntity<ApiResponse<List<RouteOnlyDto>>> getAllRoutes() {
        List<RouteOnlyDto> routeDtos = getAllRoutesData();
        return ResponseEntity.ok(new ApiResponse<>("Danh sách tuyến đường", routeDtos));
    }

    @Override
    @Cacheable(value = "route", key = "#id")
    public RouteDto getRouteByIdData(UUID id) {
        return routeRepository.findByIdWithAllRelations(id)
                .map(routeMapper::toRouteDto)
                .orElseThrow(() -> new RouteNotFound("Tuyến đường với ID " + id + " không tồn tại"));
    }

    @Override
    public ResponseEntity<ApiResponse<RouteDto>> getRouteById(UUID id) {
        RouteDto routeDto = getRouteByIdData(id);
        return ResponseEntity.ok(new ApiResponse<>("Thông tin tuyến đường", routeDto));
    }

    @Override
    public ResponseEntity<?> addRoute(RouteModel route) {
        RouteModel savedRoute = routeRepository.save(route);
        clearCache();
        RouteDto responseDto = routeMapper.toRouteDto(savedRoute);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(new ApiResponse<>("Tuyến đường đã được thêm thành công!", responseDto));
    }

    @Transactional
    @Override
    public ResponseEntity<?> updateRoute(UUID id, RouteModel updatedRoute) {
        RouteModel existingRoute = routeRepository.findById(id)
                .orElseThrow(() -> new RouteNotFound("Tuyến đường với ID " + id + " không tồn tại"));
        existingRoute.setRouteNumber(updatedRoute.getRouteNumber());
        existingRoute.setRouteName(updatedRoute.getRouteName());
        RouteModel savedRoute = routeRepository.save(existingRoute);
        clearCache();
        RouteDto responseDto = routeMapper.toRouteDto(savedRoute);
        return ResponseEntity.ok(new ApiResponse<>("Tuyến đường đã được cập nhật thành công!", responseDto));
    }

    @Transactional
    @Override
    public ResponseEntity<?> deleteRoute(UUID id) {
        RouteModel existingRoute = routeRepository.findById(id)
                .orElseThrow(() -> new RouteNotFound("Tuyến đường với ID " + id + " không tồn tại"));
        stopRepository.deleteByRouteId(id);
        timeLineRepository.deleteByRouteId(id);
        routeRepository.delete(existingRoute);
        clearCache();
        return ResponseEntity.ok(new ApiResponse<>("Tuyến đường đã bị xóa thành công!", null));
    }

    @Override
    @Cacheable(value = "stops", key = "#routeId + #direction")
    public ResponseEntity<ApiResponse<List<StopDto>>> getRouteStops(UUID routeId, String direction) {
        List<StopModel> stops = stopRepository.findByRouteId(routeId);
        List<StopDto> stopDtos = stopMapper.toStopDtoList(stops);
        return ResponseEntity.ok(new ApiResponse<>("Danh sách điểm dừng", stopDtos));
    }

    @Override
    @Cacheable(value = "timelines", key = "#routeId + #direction")
    public ResponseEntity<ApiResponse<List<TimelineDto>>> getRouteTimelines(UUID routeId, String direction) {
        List<TimeLineModel> timeLines = timeLineRepository.findByRouteId(routeId);
        List<TimelineDto> timeLineDtos = timelineMapper.toTimelineDtoList(timeLines);
        return ResponseEntity.ok(new ApiResponse<>("Danh sách thời gian", timeLineDtos));
    }

    @Override
    @Cacheable(value = "routesByName", key = "#routeName")
    public ResponseEntity<ApiResponse<List<RouteDto>>> getRouteByRouteName(String routeName) {
        List<RouteModel> routes = routeRepository.findByRouteNameWithAllRelations(routeName);
        List<RouteDto> routeDtos = routeMapper.toRouteDtoList(routes);
        return ResponseEntity.ok(new ApiResponse<>("Danh sách tuyến đường", routeDtos));
    }

    @Override
    @Cacheable(value = "returnRoute", key = "#routeId")
    public ResponseEntity<ApiResponse<RouteDto>> getReturnRoute(UUID routeId) {
        List<RouteModel> matchingRoutes = routeRepository
                .findByRouteNumber(routeRepository.findById(routeId).get().getRouteNumber());
        RouteModel returnRoute = matchingRoutes.stream().filter(route -> !route.getId().equals(routeId)).findFirst()
                .orElseThrow(() -> new RouteNotFound("Không tìm thấy tuyến lượt về"));
        RouteDto returnRouteDto = routeMapper.toRouteDto(returnRoute);
        return ResponseEntity.ok(new ApiResponse<>("Thông tin tuyến lượt về", returnRouteDto));
    }

    // @Override
    // @Cacheable(value = "routes", key = "'all_routes'")
    // public List<RouteOnlyDto> getAllRoutesData() {
    // List<RouteModel> routes = routeRepository.findAll();
    // if (routes.isEmpty()) {
    // throw new RouteNotFound("Không có tuyến xe nào trong hệ thống");
    // }
    // return routeMapper.toRouteOnlyDtoList(routes);
    // }

    // @Override
    // public ResponseEntity<ApiResponse<List<RouteOnlyDto>>> getAllRoutes() {
    // List<RouteOnlyDto> routeDtos = getAllRoutesData();
    // return ResponseEntity.ok(new ApiResponse<>("Danh sách tuyến đường",
    // routeDtos));
    // }

    // @Override
    // @Cacheable(value = "route", key = "#id")
    // public RouteDto getRouteByIdData(UUID id) {
    // return routeRepository.findByIdWithAllRelations(id)
    // .map(routeMapper::toRouteDto)
    // .orElseThrow(() -> new RouteNotFound("Tuyến đường với ID " + id + " không tồn
    // tại"));
    // }

    // @Override
    // public ResponseEntity<ApiResponse<RouteDto>> getRouteById(UUID id) {
    // RouteDto routeDto = getRouteByIdData(id);
    // return ResponseEntity.ok(new ApiResponse<>("Thông tin tuyến đường",
    // routeDto));
    // }

    // @Override
    // @CachePut(value = "route", key = "#result.body.data.id")
    // public ResponseEntity<?> addRoute(RouteModel route) {
    // RouteModel savedRoute = routeRepository.save(route);
    // RouteDto responseDto = routeMapper.toRouteDto(savedRoute);

    // return ResponseEntity.status(HttpStatus.CREATED).body(
    // new ApiResponse<>("Tuyến đường đã được thêm thành công!", responseDto));
    // }

    // @Transactional
    // @Override
    // @CachePut(value = "route", key = "#id")
    // @CacheEvict(value = "routes", allEntries = true)
    // public ResponseEntity<?> updateRoute(UUID id, RouteModel updatedRoute) {
    // RouteModel existingRoute = routeRepository.findById(id)
    // .orElseThrow(() -> new RouteNotFound("Tuyến đường với ID " + id + " không tồn
    // tại"));

    // // update
    // existingRoute.setRouteNumber(updatedRoute.getRouteNumber());
    // existingRoute.setRouteName(updatedRoute.getRouteName());
    // existingRoute.setStartTime(updatedRoute.getStartTime());
    // existingRoute.setEndTime(updatedRoute.getEndTime());
    // existingRoute.setRoutePrice(updatedRoute.getRoutePrice());
    // existingRoute.setIntervalMinutes(updatedRoute.getIntervalMinutes());
    // existingRoute.setLengthKm(updatedRoute.getLengthKm());
    // existingRoute.setIntervalMinutes(updatedRoute.getIntervalMinutes());

    // // if the relationship has any update, change it here
    // if (updatedRoute.getBuses() != null) {
    // existingRoute.setBuses(updatedRoute.getBuses());
    // }
    // if (updatedRoute.getStops() != null) {
    // existingRoute.setStops(updatedRoute.getStops());
    // }
    // if (updatedRoute.getTimeLines() != null) {
    // existingRoute.setTimeLines(updatedRoute.getTimeLines());
    // }

    // // save db
    // RouteModel savedRoute = routeRepository.save(existingRoute);
    // // return dto
    // RouteDto responseDto = routeMapper.toRouteDto(savedRoute);

    // return ResponseEntity.ok(new ApiResponse<>("Tuyến đường đã được cập nhật
    // thành công!", responseDto));
    // }

    // @Override
    // @CacheEvict(value = { "route", "routes", "routesByName", "stops",
    // "timelines", "returnRoute" }, allEntries = true)
    // public ResponseEntity<?> deleteRoute(UUID id) {
    // RouteModel existingRoute = routeRepository.findById(id)
    // .orElseThrow(() -> new RouteNotFound("Tuyến đường với ID " + id + " không tồn
    // tại"));

    // // delete relation before delete route
    // stopRepository.deleteByRouteId(id);
    // timeLineRepository.deleteByRouteId(id);

    // routeRepository.delete(existingRoute);

    // return ResponseEntity.ok(new ApiResponse<>("Tuyến đường đã bị xóa thành
    // công!", null));
    // }

    // @Override
    // @Cacheable(value = "stops", key = "#routeId + #direction")
    // public ResponseEntity<ApiResponse<List<StopDto>>> getRouteStops(UUID routeId,
    // String direction) {
    // routeRepository.findById(routeId)
    // .orElseThrow(() -> new RouteNotFound("Tuyến xe không tồn tại"));

    // List<StopModel> stops;

    // if (direction != null && !direction.isEmpty()) {
    // try {
    // DirectionEnum directionEnum = DirectionEnum.valueOf(direction.toUpperCase());
    // stops = stopRepository.findByRouteIdAndDirection(routeId, directionEnum);
    // } catch (IllegalArgumentException e) {
    // return ResponseEntity.status(HttpStatus.BAD_REQUEST)
    // .body(new ApiResponse<>("Direction không hợp lệ: " + direction,
    // List.of()));
    // }
    // } else {
    // stops = stopRepository.findByRouteId(routeId);
    // }

    // List<StopDto> stopDtos = stopMapper.toStopDtoList(stops);

    // return ResponseEntity.ok(new ApiResponse<>("Danh sách các điểm dừng của
    // tuyến", stopDtos));
    // }

    // @Override
    // @Cacheable(value = "timelines", key = "#routeId + #direction")
    // public ResponseEntity<ApiResponse<List<TimelineDto>>> getRouteTimelines(UUID
    // routeId, String direction) {
    // routeRepository.findById(routeId)
    // .orElseThrow(() -> new RouteNotFound("Tuyến xe với ID " + routeId + " không
    // tồn tại"));

    // List<TimeLineModel> timeLines;

    // if (direction != null && !direction.isEmpty()) {
    // try {
    // DirectionEnum directionEnum = DirectionEnum.valueOf(direction.toUpperCase());
    // timeLines = timeLineRepository.findByRouteIdAndDirection(routeId,
    // directionEnum);
    // } catch (IllegalArgumentException e) {
    // return ResponseEntity.status(HttpStatus.BAD_REQUEST)
    // .body(new ApiResponse<>("Direction không hợp lệ: " + direction,
    // List.of()));
    // }
    // } else {
    // timeLines = timeLineRepository.findByRouteId(routeId);
    // }

    // List<TimelineDto> timeLineDtos = timelineMapper.toTimelineDtoList(timeLines);

    // return ResponseEntity.ok(new ApiResponse<>("Danh sách thời gian khởi hành của
    // tuyến", timeLineDtos));
    // }

    // @Override
    // @Cacheable(value = "routesByName", key = "#routeName")
    // public ResponseEntity<ApiResponse<List<RouteDto>>> getRouteByRouteName(String
    // routeName) {
    // List<RouteModel> routes =
    // routeRepository.findByRouteNameWithAllRelations(routeName);

    // if (routes.isEmpty()) {
    // return ResponseEntity.status(HttpStatus.NOT_FOUND)
    // .body(new ApiResponse<>("Không tìm thấy tuyến đường có tên: " + routeName,
    // List.of()));
    // }

    // List<RouteDto> routeDtos = routeMapper.toRouteDtoList(routes);

    // return ResponseEntity.ok(new ApiResponse<>("Danh sách tuyến đường",
    // routeDtos));
    // }

    // @Override
    // @Cacheable(value = "returnRoute", key = "#routeId")
    // public ResponseEntity<ApiResponse<RouteDto>> getReturnRoute(UUID routeId) {
    // RouteModel currentRoute = routeRepository.findById(routeId)
    // .orElseThrow(() -> new RouteNotFound(
    // "Tuyến đường với ID " + routeId + " không tồn tại"));

    // List<RouteModel> matchingRoutes =
    // routeRepository.findByRouteNumber(currentRoute.getRouteNumber());

    // // get route which has the same route number except the current route
    // RouteModel returnRoute = matchingRoutes.stream()
    // .filter(route -> !route.getId().equals(routeId))
    // .findFirst()
    // .orElseThrow(() -> new RouteNotFound("Không tìm thấy tuyến lượt về cho tuyến
    // này"));

    // RouteDto returnRouteDto = routeMapper.toRouteDto(returnRoute);

    // return ResponseEntity.ok(new ApiResponse<>("Thông tin tuyến lượt về",
    // returnRouteDto));
    // }
}
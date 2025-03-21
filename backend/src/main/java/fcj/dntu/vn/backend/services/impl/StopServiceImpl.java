package fcj.dntu.vn.backend.services.impl;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.CachePut;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.cache.annotation.Caching;
import org.springframework.context.ApplicationContext;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.ObjectMapper;

import fcj.dntu.vn.backend.dtos.StopDto;

import fcj.dntu.vn.backend.exceptions.RouteNotFound;
import fcj.dntu.vn.backend.exceptions.responses.ApiResponse;
import fcj.dntu.vn.backend.mapper.StopMapper;
import fcj.dntu.vn.backend.models.RouteModel;
import fcj.dntu.vn.backend.models.StopModel;
import fcj.dntu.vn.backend.repositories.RouteRepository;
import fcj.dntu.vn.backend.repositories.StopRepository;
import fcj.dntu.vn.backend.services.StopService;

@Service
public class StopServiceImpl implements StopService {

    private final RouteRepository routeRepository;
    private final StopRepository stopRepository;
    private final StopMapper stopMapper;
    private final ApplicationContext applicationContext;

    @Autowired
    private ObjectMapper objectMapper;

    public StopServiceImpl(RouteRepository routeRepository, StopRepository stopRepository, StopMapper stopMapper,
            ApplicationContext applicationContext) {
        this.routeRepository = routeRepository;
        this.stopRepository = stopRepository;
        this.stopMapper = stopMapper;
        this.applicationContext = applicationContext;
    }

    @Override
    @Cacheable(value = "stops", key = "'all_stops'")
    public List<StopDto> getAllStopsData() {
        System.out.println("CACHE MISS: Loading stops from database...");
        List<StopModel> stops = stopRepository.findAll();
        if (stops.isEmpty()) {
            throw new RouteNotFound("Không có trạm dừng nào trong hệ thống");
        }
        return stopMapper.toStopDtoList(stops);
    }

    @Override
    public ResponseEntity<ApiResponse<List<StopDto>>> getAllStops() {
        StopService self = applicationContext.getBean(StopService.class);
        List<StopDto> stopDtos = self.getAllStopsData();
        return ResponseEntity.ok(new ApiResponse<>("Danh sách trạm dừng", stopDtos));
    }

    @Override
    @Cacheable(value = "stops", key = "#id")
    public StopDto getStopByIdData(UUID id) {
        return stopRepository.findById(id)
                .map(stopMapper::toStopDto)
                .orElseThrow(() -> new RouteNotFound("Trạm dừng với ID " + id + " không tồn tại"));
    }

    @Override
    public ResponseEntity<ApiResponse<StopDto>> getStopById(UUID id) {
        StopService self = applicationContext.getBean(StopService.class);
        Object cachedData = self.getStopByIdData(id);

        StopDto stopDto;
        if (cachedData instanceof StopDto) {
            stopDto = (StopDto) cachedData;
        } else if (cachedData instanceof LinkedHashMap) {
            stopDto = objectMapper.convertValue(cachedData, StopDto.class);
        } else {
            throw new RuntimeException("Dữ liệu cache không hợp lệ: " + cachedData.getClass().getName());
        }
        return ResponseEntity.ok(new ApiResponse<>("Thông tin trạm dừng", stopDto));
    }

    @Override
    @CacheEvict(value = "stops", key = "'all_stops'")
    @CachePut(value = "stops", key = "#result.body.data.id")
    public ResponseEntity<?> addStop(StopDto stopDto) {
        StopModel stopModel = stopMapper.toStopModel(stopDto);

        if (stopDto.getRouteId() != null) {
            RouteModel route = routeRepository.findById(stopDto.getRouteId())
                    .orElseThrow(() -> new RouteNotFound("Trạm dừng không tồn tại"));
            stopModel.setRoute(route);
        }

        StopModel savedStop = stopRepository.save(stopModel);

        return ResponseEntity.status(HttpStatus.CREATED).body(
                new ApiResponse<>("Trạm dừng đã được thêm thành công!",
                        stopMapper.toStopDto(savedStop)));
    }

    @Override
    @CachePut(value = "stops", key = "#id")
    @CacheEvict(value = "stops", key = "'all_stops'")
    public ResponseEntity<?> updateStop(UUID id, StopDto updatedStop) {
        StopModel existingStop = stopRepository.findById(id)
                .orElseThrow(() -> new RouteNotFound("Trạm dừng với ID " + id + " không tồn tại"));

        // update
        stopMapper.updateStopFromDto(updatedStop, existingStop);

        if (updatedStop.getRouteId() != null) {
            RouteModel route = routeRepository.findById(updatedStop.getRouteId())
                    .orElseThrow(() -> new RouteNotFound("Tuyến đường không tồn tại"));
            existingStop.setRoute(route);
        }

        StopModel savedStop = stopRepository.save(existingStop);

        return ResponseEntity
                .ok(new ApiResponse<>("Trạm dừng đã được cập nhật thành công!", stopMapper.toStopDto(savedStop)));
    }

    @Override
    @Caching(evict = {
            @CacheEvict(value = "stops", key = "#id"),
            @CacheEvict(value = "stops", key = "'all_stops'")
    })
    public ResponseEntity<?> deleteStop(UUID id) {
        StopModel existingModel = stopRepository.findById(id)
                .orElseThrow(() -> new RouteNotFound("Trạm dừng với ID " + id + " không tồn tại"));

        stopRepository.delete(existingModel);

        return ResponseEntity.ok(new ApiResponse<>("Trạm dừng đã xóa thành công!", null));
    }

    @Override
    public ResponseEntity<ApiResponse<List<StopDto>>> findNearbyStops(double latitude, double longitude) {
        List<StopModel> nearbyStops = stopRepository.findStopNearby(latitude, longitude, 500);

        if (nearbyStops.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(new ApiResponse<>("Không tìm thấy điểm dừng nào trong phạm vi 500m", List.of()));
        }

        List<StopDto> stopDtos = stopMapper.toStopDtoList(nearbyStops);

        return ResponseEntity.ok(new ApiResponse<>("Danh sách điểm dừng gần bạn", stopDtos));
    }
}

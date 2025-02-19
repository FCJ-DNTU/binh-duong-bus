package fcj.dntu.vn.backend.services.impl;

import java.util.List;
import java.util.UUID;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

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

    public StopServiceImpl(RouteRepository routeRepository, StopRepository stopRepository, StopMapper stopMapper) {
        this.routeRepository = routeRepository;
        this.stopRepository = stopRepository;
        this.stopMapper = stopMapper;
    }

    @Override
    public ResponseEntity<ApiResponse<List<StopDto>>> getAllStops() {
        List<StopModel> stops = stopRepository.findAll();
        if (stops.isEmpty()) {
            throw new RouteNotFound("Không có trạm dừng nào trong hệ thống");
        }

        List<StopDto> stopDtos = stopMapper.toStopDtoList(stops);

        return ResponseEntity.ok(new ApiResponse<>("Danh sách trạm dừng", stopDtos));
    }

    @Override
    public ResponseEntity<ApiResponse<StopDto>> getStopById(UUID id) {
        StopModel stop = stopRepository.findById(id)
                .orElseThrow(() -> new RouteNotFound("Trạm dừng với ID " + id + " không tồn tại"));

        StopDto stopDto = stopMapper.toStopDto(stop);

        return ResponseEntity.ok(new ApiResponse<>("Thông tin trạm dừng", stopDto));
    }

    @Override
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

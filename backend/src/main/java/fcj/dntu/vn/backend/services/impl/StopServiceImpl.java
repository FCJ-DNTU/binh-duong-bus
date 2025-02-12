package fcj.dntu.vn.backend.services.impl;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

import org.locationtech.jts.geom.Point;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import fcj.dntu.vn.backend.dtos.LocationDto;
import fcj.dntu.vn.backend.dtos.StopDto;
import fcj.dntu.vn.backend.exceptions.ErrorResponse;

import fcj.dntu.vn.backend.exceptions.RouteNotFound;
import fcj.dntu.vn.backend.exceptions.responses.ApiResponse;
import fcj.dntu.vn.backend.models.RouteModel;
import fcj.dntu.vn.backend.models.StopModel;
import fcj.dntu.vn.backend.repositories.RouteRepository;
import fcj.dntu.vn.backend.repositories.StopRepository;
import fcj.dntu.vn.backend.services.StopService;
import fcj.dntu.vn.backend.utils.GeoUtils;

@Service
public class StopServiceImpl implements StopService {

    @Autowired
    StopRepository stopRepository;

    @Autowired
    RouteRepository routeRepository;

    @Override
    public ResponseEntity<ApiResponse<List<StopDto>>> getAllStops() {
        try {
            List<StopModel> stops = stopRepository.findAll();
            if (stops.isEmpty()) {
                throw new RouteNotFound("Không có trạm dừng nào trong hệ thống");
            }

            // transfer StopModel to StopDTO
            List<StopDto> stopDtos = stops.stream().map(stop -> new StopDto(
                    stop.getId(),
                    stop.getStopName(),
                    GeoUtils.pointToLocation(stop.getLocation()),
                    stop.getSequence(),
                    stop.getDirection(),
                    stop.getRoute().getId()))
                    .collect(Collectors.toList());

            return ResponseEntity.ok(new ApiResponse<>("Danh sách trạm dừng", stopDtos));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ApiResponse<>("Đã xảy ra lỗi: " + e.getMessage(), null));
        }
    }

    @Override
    public ResponseEntity<ApiResponse<StopDto>> getStopById(UUID id) {
        try {
            StopModel stop = stopRepository.findById(id)
                    .orElseThrow(() -> new RouteNotFound("Trạm dừng với ID " + id + " không tồn tại"));

            StopDto stopDto = new StopDto(
                    stop.getId(),
                    stop.getStopName(),
                    GeoUtils.pointToLocation(stop.getLocation()),
                    stop.getSequence(),
                    stop.getDirection(),
                    stop.getRoute().getId());

            return ResponseEntity.ok(new ApiResponse<>("Thông tin trạm dừng", stopDto));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ApiResponse<>("Đã xảy ra lỗi: " + e.getMessage(), null));
        }
    }

    @Override
    public ResponseEntity<?> addStop(StopDto stopDto) {
        try {
            StopModel stopModel = new StopModel();
            stopModel.setStopName(stopDto.getStopName());
            stopModel.setSequence(stopDto.getSequence());
            stopModel.setDirection(stopDto.getDirection());

            if (stopDto.getLocation() != null) {
                Point location = GeoUtils.locationDtoToPoint(stopDto.getLocation());
                stopModel.setLocation(location);
            }

            if (stopDto.getRouteId() != null) {
                RouteModel route = routeRepository.findById(stopDto.getRouteId())
                        .orElseThrow(() -> new RouteNotFound("Trạm dừng không tồn tại"));
                stopModel.setRoute(route);
            }

            StopModel savedStop = stopRepository.save(stopModel);

            return ResponseEntity.status(HttpStatus.CREATED).body(
                    new ApiResponse<>("Trạm dừng đã được thêm thành công!", savedStop));

        } catch (Exception e) {
            String path = ServletUriComponentsBuilder.fromCurrentRequest().toUriString();
            ErrorResponse errorResponse = new ErrorResponse(
                    HttpStatus.INTERNAL_SERVER_ERROR,
                    "Lỗi khi tạo trạm dừng: " + e.getMessage(),
                    path);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    @Override
    public ResponseEntity<?> updateStop(UUID id, StopDto updatedStop) {
        try {
            StopModel existingStop = stopRepository.findById(id)
                    .orElseThrow(() -> new RouteNotFound("Trạm dừng với ID " + id + " không tồn tại"));

            // update
            existingStop.setStopName(updatedStop.getStopName());
            existingStop.setSequence(updatedStop.getSequence());
            existingStop.setDirection(updatedStop.getDirection());

            if (updatedStop.getLocation() != null) {
                Point location = GeoUtils.locationDtoToPoint(updatedStop.getLocation());
                existingStop.setLocation(location);
            }

            if (updatedStop.getRouteId() != null) {
                RouteModel route = routeRepository.findById(updatedStop.getRouteId())
                        .orElseThrow(() -> new RouteNotFound("Tuyến đường không tồn tại"));
                existingStop.setRoute(route);
            }

            StopModel savedStop = stopRepository.save(existingStop);

            return ResponseEntity.ok(new ApiResponse<>("Trạm dừng đã được cập nhật thành công!", savedStop));

        } catch (Exception e) {
            String path = ServletUriComponentsBuilder.fromCurrentRequest().toUriString();
            ErrorResponse errorResponse = new ErrorResponse(
                    HttpStatus.INTERNAL_SERVER_ERROR,
                    "Lỗi khi cập nhật trạm dừng: " + e.getMessage(),
                    path);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    @Override
    public ResponseEntity<?> deleteStop(UUID id) {
        try {
            StopModel existingModel = stopRepository.findById(id)
                    .orElseThrow(() -> new RouteNotFound("Trạm dừng với ID " + id + " không tồn tại"));

            stopRepository.delete(existingModel);

            return ResponseEntity.ok(new ApiResponse<>("Trạm dừng đã xóa thành công!", null));

        } catch (Exception e) {
            String path = ServletUriComponentsBuilder.fromCurrentRequest().toUriString();
            ErrorResponse errorResponse = new ErrorResponse(
                    HttpStatus.INTERNAL_SERVER_ERROR,
                    "Lỗi khi xóa trạm dừng: " + e.getMessage(),
                    path);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    @Override
    public ResponseEntity<ApiResponse<List<StopDto>>> findNearbyStops(double latitude, double longitude) {
        try {
            List<StopModel> nearbyStops = stopRepository.findStopNearby(latitude, longitude, 500);

            if (nearbyStops.isEmpty()) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body(new ApiResponse<>("Không tìm thấy điểm dừng nào trong phạm vi 500m", List.of()));
            }

            List<StopDto> stopDtos = nearbyStops.stream().map(stop -> new StopDto(
                    stop.getId(),
                    stop.getStopName(),
                    new LocationDto(stop.getLocation().getY(), stop.getLocation().getX()), // lat, lng
                    stop.getSequence(),
                    stop.getDirection(),
                    stop.getRoute().getId())).collect(Collectors.toList());

            return ResponseEntity.ok(new ApiResponse<>("Danh sách điểm dừng gần bạn", stopDtos));

        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ApiResponse<>("Lỗi khi tìm điểm dừng: " + e.getMessage(), List.of()));
        }
    }

}

package fcj.dntu.vn.backend.services.impl;

import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import fcj.dntu.vn.backend.dtos.TimelineDto;
import fcj.dntu.vn.backend.exceptions.ErrorResponse;
import fcj.dntu.vn.backend.exceptions.RouteNotFound;
import fcj.dntu.vn.backend.exceptions.responses.ApiResponse;
import fcj.dntu.vn.backend.models.RouteModel;
import fcj.dntu.vn.backend.models.TimeLineModel;
import fcj.dntu.vn.backend.repositories.RouteRepository;
import fcj.dntu.vn.backend.repositories.TimeLineRepository;
import fcj.dntu.vn.backend.services.TimelineService;

@Service
public class TimelineServiceImpl implements TimelineService {

    @Autowired
    TimeLineRepository timelineRepository;

    @Autowired
    RouteRepository routeRepository;

    @Override
    public ResponseEntity<ApiResponse<List<TimelineDto>>> getAllTimelines() {
        List<TimeLineModel> timelines = timelineRepository.findAll();
        if (timelines.isEmpty()) {
            throw new RouteNotFound("Không có timeline nào trong hệ thống");
        }

        List<TimelineDto> timeLineDtos = timelines.stream()
                .map(timeLine -> new TimelineDto(
                        timeLine.getId(),
                        timeLine.getDirection(),
                        timeLine.getDepartureTime(),
                        timeLine.getRoute().getId()))
                .toList();

        return ResponseEntity.ok(new ApiResponse<>("Danh sách timelines", timeLineDtos));
    }

    @Override
    public ResponseEntity<ApiResponse<TimelineDto>> getTimelineById(UUID id) {
        TimeLineModel timeline = timelineRepository.findById(id)
                .orElseThrow(() -> new RouteNotFound("Timeline với ID " + id + " không tồn tại"));

        TimelineDto timelineDto = new TimelineDto(
                timeline.getId(),
                timeline.getDirection(),
                timeline.getDepartureTime(),
                timeline.getRoute().getId());

        return ResponseEntity.ok(new ApiResponse<>("Thông tin timeline", timelineDto));
    }

    @Override
    public ResponseEntity<?> addTimeline(@RequestBody TimelineDto timelineDto) {
        try {
            if (timelineDto.getRouteId() == null) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                        .body(new ApiResponse<>("Route ID is missing", null));
            }

            UUID routeId = timelineDto.getRouteId();
            RouteModel route = routeRepository.findById(routeId)
                    .orElseThrow(() -> new RouteNotFound("Route with ID " + routeId + " not found"));

            TimeLineModel timeline = TimeLineModel.builder()
                    .direction(timelineDto.getDirection())
                    .departureTime(timelineDto.getDepartureTime())
                    .route(route)
                    .build();

            TimeLineModel savedTimeline = timelineRepository.save(timeline);

            TimelineDto savedTimelineDto = new TimelineDto(
                    savedTimeline.getId(),
                    savedTimeline.getDirection(),
                    savedTimeline.getDepartureTime(),
                    savedTimeline.getRoute().getId());

            return ResponseEntity.status(HttpStatus.CREATED).body(
                    new ApiResponse<>("Timeline đã được thêm thành công!", savedTimelineDto));

        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(
                    new ErrorResponse(HttpStatus.BAD_REQUEST, e.getMessage(),
                            ServletUriComponentsBuilder.fromCurrentRequest().toUriString()));
        } catch (Exception e) {
            String path = ServletUriComponentsBuilder.fromCurrentRequest().toUriString();
            ErrorResponse errorResponse = new ErrorResponse(
                    HttpStatus.INTERNAL_SERVER_ERROR,
                    "Lỗi khi tạo timeline: " + e.getMessage(),
                    path);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    @Override
    public ResponseEntity<?> updateTimeline(UUID id, TimelineDto timelineDto) {
        try {
            TimeLineModel existingTimeline = timelineRepository.findById(id)
                    .orElseThrow(() -> new RouteNotFound("Timeline với ID " + id + " không tồn tại"));

            existingTimeline.setDirection(timelineDto.getDirection());
            existingTimeline.setDepartureTime(timelineDto.getDepartureTime());

            if (timelineDto.getRouteId() != null) {
                RouteModel route = routeRepository.findById(timelineDto.getRouteId())
                        .orElseThrow(
                                () -> new RouteNotFound("Route with ID " + timelineDto.getRouteId() + " not found"));
                existingTimeline.setRoute(route);
            }

            TimeLineModel savedTimeline = timelineRepository.save(existingTimeline);

            TimelineDto savedTimelineDto = new TimelineDto(
                    savedTimeline.getId(),
                    savedTimeline.getDirection(),
                    savedTimeline.getDepartureTime(),
                    savedTimeline.getRoute().getId());

            return ResponseEntity.ok(new ApiResponse<>("Timeline đã được cập nhật thành công!", savedTimelineDto));

        } catch (Exception e) {
            String path = ServletUriComponentsBuilder.fromCurrentRequest().toUriString();
            ErrorResponse errorResponse = new ErrorResponse(
                    HttpStatus.INTERNAL_SERVER_ERROR,
                    "Lỗi khi cập nhật timeline: " + e.getMessage(),
                    path);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    @Override
    public ResponseEntity<?> deleteTimeline(UUID id) {
        try {
            TimeLineModel existingTimeline = timelineRepository.findById(id)
                    .orElseThrow(() -> new RouteNotFound("Timeline với ID " + id + " không tồn tại"));

            timelineRepository.delete(existingTimeline);

            return ResponseEntity.ok(new ApiResponse<>("Timeline đã xóa thành công!", null));

        } catch (Exception e) {
            String path = ServletUriComponentsBuilder.fromCurrentRequest().toUriString();
            ErrorResponse errorResponse = new ErrorResponse(
                    HttpStatus.INTERNAL_SERVER_ERROR,
                    "Lỗi khi xóa timeline: " + e.getMessage(),
                    path);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

}

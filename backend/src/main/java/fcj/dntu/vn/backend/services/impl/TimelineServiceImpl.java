package fcj.dntu.vn.backend.services.impl;

import java.util.List;
import java.util.UUID;

import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestBody;

import fcj.dntu.vn.backend.dtos.TimelineDto;
import fcj.dntu.vn.backend.exceptions.RouteNotFound;
import fcj.dntu.vn.backend.exceptions.responses.ApiResponse;
import fcj.dntu.vn.backend.mapper.TimelineMapper;
import fcj.dntu.vn.backend.models.RouteModel;
import fcj.dntu.vn.backend.models.TimeLineModel;
import fcj.dntu.vn.backend.repositories.RouteRepository;
import fcj.dntu.vn.backend.repositories.TimeLineRepository;
import fcj.dntu.vn.backend.services.TimelineService;

@Service
public class TimelineServiceImpl implements TimelineService {

        private final RouteRepository routeRepository;
        private final TimeLineRepository timelineRepository;
        private final TimelineMapper timelineMapper;

        public TimelineServiceImpl(RouteRepository routeRepository, TimeLineRepository timelineRepository,
                        TimelineMapper timelineMapper) {
                this.routeRepository = routeRepository;
                this.timelineRepository = timelineRepository;
                this.timelineMapper = timelineMapper;
        }

        @Override
        @Cacheable(value = "timelines")
        public ResponseEntity<ApiResponse<List<TimelineDto>>> getAllTimelines() {
                List<TimeLineModel> timelines = timelineRepository.findAll();
                if (timelines.isEmpty()) {
                        throw new RouteNotFound("Không có timeline nào trong hệ thống");
                }

                List<TimelineDto> timelineDtos = timelineMapper.toTimelineDtoList(timelines);

                return ResponseEntity.ok(new ApiResponse<>("Danh sách timelines", timelineDtos));
        }

        @Override
        @Cacheable(value = "timeline", key = "#id")
        public ResponseEntity<ApiResponse<TimelineDto>> getTimelineById(UUID id) {
                TimeLineModel timeline = timelineRepository.findById(id)
                                .orElseThrow(() -> new RouteNotFound(
                                                "Timeline với ID " + id + " không tồn tại"));

                TimelineDto timelineDto = timelineMapper.toTimelineDto(timeline);

                return ResponseEntity.ok(new ApiResponse<>("Thông tin timeline", timelineDto));
        }

        @Override
        @CacheEvict(value = { "timelines", "timeline" }, allEntries = true)
        public ResponseEntity<?> addTimeline(@RequestBody TimelineDto timelineDto) {
                if (timelineDto.getRouteId() == null) {
                        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                                        .body(new ApiResponse<>("Route ID is missing", null));
                }

                RouteModel route = routeRepository.findById(timelineDto.getRouteId())
                                .orElseThrow(() -> new RouteNotFound(
                                                "Route với ID " + timelineDto.getRouteId() + " không tồn tại"));

                TimeLineModel timeline = timelineMapper.toTimelineModel(timelineDto);
                timeline.setRoute(route);

                TimeLineModel savedTimeline = timelineRepository.save(timeline);
                TimelineDto savedTimelineDto = timelineMapper.toTimelineDto(savedTimeline);

                return ResponseEntity.status(HttpStatus.CREATED)
                                .body(new ApiResponse<>("Timeline đã được thêm thành công!", savedTimelineDto));
        }

        @Override
        @CacheEvict(value = { "timelines", "timeline" }, allEntries = true)
        public ResponseEntity<?> updateTimeline(UUID id, TimelineDto timelineDto) {
                TimeLineModel existingTimeline = timelineRepository.findById(id)
                                .orElseThrow(() -> new RouteNotFound("Timeline với ID " + id + " không tồn tại"));

                timelineMapper.updateTimelineFromDto(timelineDto, existingTimeline);

                if (timelineDto.getRouteId() != null) {
                        RouteModel route = routeRepository.findById(timelineDto.getRouteId())
                                        .orElseThrow(() -> new RouteNotFound(
                                                        "Route với ID " + timelineDto.getRouteId() + " không tồn tại"));
                        existingTimeline.setRoute(route);
                }

                TimeLineModel savedTimeline = timelineRepository.save(existingTimeline);
                TimelineDto savedTimelineDto = timelineMapper.toTimelineDto(savedTimeline);

                return ResponseEntity.ok(new ApiResponse<>("Timeline đã được cập nhật thành công!", savedTimelineDto));
        }

        @Override
        @CacheEvict(value = { "timelines", "timeline" }, allEntries = true)
        public ResponseEntity<?> deleteTimeline(UUID id) {
                TimeLineModel existingTimeline = timelineRepository.findById(id)
                                .orElseThrow(() -> new RouteNotFound(
                                                "Timeline với ID " + id + " không tồn tại"));

                timelineRepository.delete(existingTimeline);

                return ResponseEntity.ok(new ApiResponse<>("Timeline đã xóa thành công!", null));
        }

}

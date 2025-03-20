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
import org.springframework.web.bind.annotation.RequestBody;

import com.fasterxml.jackson.databind.ObjectMapper;

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
        private final ApplicationContext applicationContext;

        @Autowired
        private ObjectMapper objectMapper;

        public TimelineServiceImpl(RouteRepository routeRepository, TimeLineRepository timelineRepository,
                        TimelineMapper timelineMapper, ApplicationContext applicationContext) {
                this.routeRepository = routeRepository;
                this.timelineRepository = timelineRepository;
                this.timelineMapper = timelineMapper;
                this.applicationContext = applicationContext;
        }

        @Override
        @Cacheable(value = "timelines", key = "'all_timelines'")
        public List<TimelineDto> getAllTimelinesData() {
                System.out.println("CACHE MISS: Loading timelines from database...");
                List<TimeLineModel> timelines = timelineRepository.findAll();
                if (timelines.isEmpty()) {
                        throw new RouteNotFound("Không có timeline nào trong hệ thống");
                }
                return timelineMapper.toTimelineDtoList(timelines);
        }

        @Override
        public ResponseEntity<ApiResponse<List<TimelineDto>>> getAllTimelines() {
                TimelineService self = applicationContext.getBean(TimelineService.class);
                List<TimelineDto> TimelineDtos = self.getAllTimelinesData();
                return ResponseEntity.ok(new ApiResponse<>("Danh sách timelines", TimelineDtos));
        }

        @Override
        @Cacheable(value = "timeline", key = "#id")
        public TimelineDto getTimelineByIdData(UUID id) {
                return timelineRepository.findById(id)
                                .map(timelineMapper::toTimelineDto)
                                .orElseThrow(() -> new RouteNotFound("Timeline với ID " + id + " không tồn tại"));
        }

        @Override
        public ResponseEntity<ApiResponse<TimelineDto>> getTimelineById(UUID id) {
                TimelineService self = applicationContext.getBean(TimelineService.class);
                Object cachedData = self.getTimelineByIdData(id);

                TimelineDto timelineDto;
                if (cachedData instanceof TimelineDto) {
                        timelineDto = (TimelineDto) cachedData;
                } else if (cachedData instanceof LinkedHashMap) {
                        timelineDto = objectMapper.convertValue(cachedData, TimelineDto.class);
                } else {
                        throw new RuntimeException("Dữ liệu cache không hợp lệ: " + cachedData.getClass().getName());
                }
                return ResponseEntity.ok(new ApiResponse<>("Thông tin trạm dừng", timelineDto));
        }

        @Override
        @CacheEvict(value = "timelines", key = "'all_timelines'")
        @CachePut(value = "timeline", key = "#result.body.data.id")
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
        @CachePut(value = "timeline", key = "#id")
        @CacheEvict(value = "timelines", key = "'all_timelines'")
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
        @Caching(evict = {
                        @CacheEvict(value = "timeline", key = "#id"),
                        @CacheEvict(value = "timelines", key = "'all_timelines'")
        })
        public ResponseEntity<?> deleteTimeline(UUID id) {
                TimeLineModel existingTimeline = timelineRepository.findById(id)
                                .orElseThrow(() -> new RouteNotFound(
                                                "Timeline với ID " + id + " không tồn tại"));

                timelineRepository.delete(existingTimeline);

                return ResponseEntity.ok(new ApiResponse<>("Timeline đã xóa thành công!", null));
        }

}

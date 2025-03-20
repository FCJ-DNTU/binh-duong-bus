package fcj.dntu.vn.backend.services;

import java.util.List;
import java.util.UUID;

import org.springframework.http.ResponseEntity;

import fcj.dntu.vn.backend.dtos.TimelineDto;
import fcj.dntu.vn.backend.exceptions.responses.ApiResponse;

public interface TimelineService {

    ResponseEntity<ApiResponse<List<TimelineDto>>> getAllTimelines();

    ResponseEntity<ApiResponse<TimelineDto>> getTimelineById(UUID id);

    ResponseEntity<?> addTimeline(TimelineDto timeline);

    ResponseEntity<?> updateTimeline(UUID id, TimelineDto updatedTimeline);

    ResponseEntity<?> deleteTimeline(UUID id);

    // cache
    List<TimelineDto> getAllTimelinesData();

    TimelineDto getTimelineByIdData(UUID id);
}

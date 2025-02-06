package fcj.dntu.vn.backend.controllers;

import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import fcj.dntu.vn.backend.dtos.TimelineDto;
import fcj.dntu.vn.backend.exceptions.responses.ApiResponse;
import fcj.dntu.vn.backend.services.TimelineService;

import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("api/timelines")
public class TimelineController {

    @Autowired
    TimelineService timelineService;

    @GetMapping()
    public ResponseEntity<ApiResponse<List<TimelineDto>>> getAllTimelines() {
        return timelineService.getAllTimelines();
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<TimelineDto>> getTimelineById(@PathVariable UUID id) {
        return timelineService.getTimelineById(id);
    }

    @PostMapping("/add")
    public ResponseEntity<?> addTimeline(@RequestBody TimelineDto timeline) {
        return timelineService.addTimeline(timeline);
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> updateTimeline(@PathVariable UUID id, @RequestBody TimelineDto updatedTimeline) {
        return timelineService.updateTimeline(id, updatedTimeline);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteTimeline(@PathVariable UUID id) {
        return timelineService.deleteTimeline(id);
    }

}

package fcj.dntu.vn.backend.controllers;

import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import fcj.dntu.vn.backend.dtos.StopDto;
import fcj.dntu.vn.backend.exceptions.responses.ApiResponse;
import fcj.dntu.vn.backend.services.StopService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@RestController
@RequestMapping("api/stops")
public class StopController {

    @Autowired
    StopService stopService;

    @GetMapping()
    public ResponseEntity<ApiResponse<List<StopDto>>> getAllStops() {
        return stopService.getAllStops();
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<StopDto>> getStopById(@PathVariable UUID id) {
        return stopService.getStopById(id);
    }

    @PostMapping("/add")
    public ResponseEntity<?> addStop(@RequestBody StopDto stop) {
        return stopService.addStop(stop);
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> updateStop(@PathVariable UUID id, @RequestBody StopDto updatedStop) {
        return stopService.updateStop(id, updatedStop);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteStop(@PathVariable UUID id) {
        return stopService.deleteStop(id);
    }

    @GetMapping("/nearby")
    public ResponseEntity<ApiResponse<List<StopDto>>> getNearbyStops(
            @RequestParam double latitude,
            @RequestParam double longitude) {
        return stopService.findNearbyStops(latitude, longitude);
    }

}

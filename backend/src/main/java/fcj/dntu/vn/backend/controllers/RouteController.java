package fcj.dntu.vn.backend.controllers;

import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import fcj.dntu.vn.backend.dtos.RouteDto;
import fcj.dntu.vn.backend.dtos.RouteOnlyDto;
import fcj.dntu.vn.backend.dtos.StopDto;
import fcj.dntu.vn.backend.dtos.TimelineDto;
import fcj.dntu.vn.backend.exceptions.responses.ApiResponse;
import fcj.dntu.vn.backend.models.RouteModel;
import fcj.dntu.vn.backend.services.RouteService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@RestController
@RequestMapping("/api/routes")
public class RouteController {

    @Autowired
    RouteService routeService;

    @GetMapping
    public ResponseEntity<ApiResponse<List<RouteOnlyDto>>> getAllRoutes() {
        return routeService.getAllRoutes();
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<RouteDto>> getRouteById(@PathVariable UUID id) {
        return routeService.getRouteById(id);
    }

    @GetMapping("/search")
    public ResponseEntity<ApiResponse<List<RouteDto>>> getRouteByName(@RequestParam("name") String routeName) {
        return routeService.getRouteByRouteName(routeName);
    }

    @GetMapping("/{routeId}/stops")
    public ResponseEntity<ApiResponse<List<StopDto>>> getRouteStops(@PathVariable UUID routeId,
            @RequestParam(required = false) String direction) {
        return routeService.getRouteStops(routeId, direction);
    }

    @GetMapping("/{routeId}/timelines")
    public ResponseEntity<ApiResponse<List<TimelineDto>>> getRouteTimelines(@PathVariable UUID routeId,
            @RequestParam(required = false) String direction) {
        return routeService.getRouteTimelines(routeId, direction);
    }

    @GetMapping("/{routeId}/return")
    public ResponseEntity<ApiResponse<RouteDto>> getReturnRoute(@PathVariable UUID routeId) {
        return routeService.getReturnRoute(routeId);
    }

    @PostMapping("/add")
    public ResponseEntity<?> addRoute(@RequestBody RouteModel route) {
        return routeService.addRoute(route);
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> updateRoute(@PathVariable UUID id, @RequestBody RouteModel updatedRoute) {
        return routeService.updateRoute(id, updatedRoute);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteRoute(@PathVariable UUID id) {
        return routeService.deleteRoute(id);
    }
}

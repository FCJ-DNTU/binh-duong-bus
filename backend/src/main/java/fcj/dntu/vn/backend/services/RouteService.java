package fcj.dntu.vn.backend.services;

import java.util.List;
import java.util.UUID;

import org.springframework.http.ResponseEntity;

import fcj.dntu.vn.backend.dtos.RouteDto;
import fcj.dntu.vn.backend.dtos.RouteOnlyDto;
import fcj.dntu.vn.backend.dtos.StopDto;
import fcj.dntu.vn.backend.dtos.TimelineDto;
import fcj.dntu.vn.backend.exceptions.responses.ApiResponse;
import fcj.dntu.vn.backend.models.RouteModel;

public interface RouteService {

    ResponseEntity<ApiResponse<List<RouteOnlyDto>>> getAllRoutes();

    ResponseEntity<ApiResponse<RouteDto>> getRouteById(UUID id);

    ResponseEntity<?> addRoute(RouteModel route);

    ResponseEntity<?> updateRoute(UUID id, RouteModel updatedRoute);

    ResponseEntity<?> deleteRoute(UUID id);

    ResponseEntity<ApiResponse<List<StopDto>>> getRouteStops(UUID routeId, String direction);

    ResponseEntity<ApiResponse<List<TimelineDto>>> getRouteTimelines(UUID routeId, String direction);

    ResponseEntity<ApiResponse<List<RouteDto>>> getRouteByRouteName(String routeName);

    ResponseEntity<ApiResponse<RouteDto>> getReturnRoute(UUID routeId);

    // cache
    List<RouteOnlyDto> getAllRoutesData();

    RouteDto getRouteByIdData(UUID id);
}
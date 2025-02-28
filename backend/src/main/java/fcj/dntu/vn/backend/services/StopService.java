package fcj.dntu.vn.backend.services;

import java.util.List;
import java.util.UUID;

import org.springframework.http.ResponseEntity;

import fcj.dntu.vn.backend.dtos.StopDto;
import fcj.dntu.vn.backend.exceptions.responses.ApiResponse;

public interface StopService {

    ResponseEntity<ApiResponse<List<StopDto>>> getAllStops();

    ResponseEntity<ApiResponse<StopDto>> getStopById(UUID id);

    ResponseEntity<?> addStop(StopDto stop);

    ResponseEntity<?> updateStop(UUID id, StopDto updatedStop);

    ResponseEntity<?> deleteStop(UUID id);

    ResponseEntity<ApiResponse<List<StopDto>>> findNearbyStops(double latitude, double longitude);

}

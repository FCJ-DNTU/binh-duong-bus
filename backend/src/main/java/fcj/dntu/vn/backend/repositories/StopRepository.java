package fcj.dntu.vn.backend.repositories;

import fcj.dntu.vn.backend.models.StopModel;
import fcj.dntu.vn.backend.models.enums.DirectionEnum;
import jakarta.transaction.Transactional;

import org.locationtech.jts.geom.Location;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface StopRepository extends JpaRepository<StopModel, UUID> {
    @Query(value = "SELECT * FROM Location WHERE ST_DWithin(location, ST_SetSRID(ST_MakePoint(?1, ?2), 4326), ?3)", nativeQuery = true)
    List<Location> findWithinDistance(double longitude, double latitude, double distanceInMeters);

    List<StopModel> findByRouteId(UUID routeId);

    List<StopModel> findByRouteIdAndDirection(UUID routeId, DirectionEnum direction);

    boolean existsByOsmNodeId(Long osmNodeId);

    @Query(value = """
                SELECT * FROM stops
                WHERE ST_DistanceSphere(location, ST_SetSRID(ST_MakePoint(?2, ?1), 4326)) <= ?3
            """, nativeQuery = true)
    List<StopModel> findStopNearby(double longitude, double latitude, int i);

    @Transactional
    void deleteByRouteId(UUID id);
}

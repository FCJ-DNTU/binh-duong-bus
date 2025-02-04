package fcj.dntu.vn.backend.repositories;

import fcj.dntu.vn.backend.models.StopModel;
import org.locationtech.jts.geom.Location;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.UUID;

public interface StopRepository extends JpaRepository<StopModel, UUID> {
    @Query(value = "SELECT * FROM Location WHERE ST_DWithin(location, ST_SetSRID(ST_MakePoint(?1, ?2), 4326), ?3)", nativeQuery = true)
    List<Location> findWithinDistance(double longitude, double latitude, double distanceInMeters);
}


package fcj.dntu.vn.backend.repositories;

import fcj.dntu.vn.backend.models.TimeLineModel;
import fcj.dntu.vn.backend.models.enums.DirectionEnum;
import jakarta.transaction.Transactional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface TimeLineRepository extends JpaRepository<TimeLineModel, UUID> {

    List<TimeLineModel> findByRouteIdAndDirection(UUID routeId, DirectionEnum direction);

    List<TimeLineModel> findByRouteId(UUID routeId);

    @Transactional
    void deleteByRouteId(UUID id);
}

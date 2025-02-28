package fcj.dntu.vn.backend.repositories;

import fcj.dntu.vn.backend.models.WayModel;
import org.springframework.data.jpa.repository.JpaRepository;

public interface WayRepository extends JpaRepository<WayModel, Long> {
    boolean existsByOsmWayId(Long osmWayId);
}

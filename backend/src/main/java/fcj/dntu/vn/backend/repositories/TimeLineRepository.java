package fcj.dntu.vn.backend.repositories;

import fcj.dntu.vn.backend.models.TimeLineModel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface TimeLineRepository extends JpaRepository<TimeLineModel, UUID> {
}

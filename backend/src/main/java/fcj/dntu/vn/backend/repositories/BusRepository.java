package fcj.dntu.vn.backend.repositories;

import fcj.dntu.vn.backend.models.BusModel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface BusRepository extends JpaRepository<BusModel, UUID> {
}

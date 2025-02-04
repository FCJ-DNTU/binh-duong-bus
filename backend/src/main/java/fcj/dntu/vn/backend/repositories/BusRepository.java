package fcj.dntu.vn.backend.repositories;

import fcj.dntu.vn.backend.models.BusModel;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface BusRepository extends JpaRepository<BusModel, UUID> {
}

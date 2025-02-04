package fcj.dntu.vn.backend.repositories;

import fcj.dntu.vn.backend.models.RouteModel;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface RouteRepository extends JpaRepository<RouteModel, UUID> {
}

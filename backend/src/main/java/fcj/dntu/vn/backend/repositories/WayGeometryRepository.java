package fcj.dntu.vn.backend.repositories;

import fcj.dntu.vn.backend.models.WayGeometryModel;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface WayGeometryRepository extends JpaRepository<WayGeometryModel, UUID> {
}

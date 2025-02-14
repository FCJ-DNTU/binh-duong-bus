package fcj.dntu.vn.backend.repositories;

import fcj.dntu.vn.backend.models.RouteModel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface RouteRepository extends JpaRepository<RouteModel, UUID> {

    List<RouteModel> findByRouteName(String routeName);

    boolean existsByOsmRelationId(Long osmRelationId);
}

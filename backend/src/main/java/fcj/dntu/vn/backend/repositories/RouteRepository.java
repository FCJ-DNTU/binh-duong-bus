package fcj.dntu.vn.backend.repositories;

import fcj.dntu.vn.backend.models.RouteModel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface RouteRepository extends JpaRepository<RouteModel, UUID> {

    boolean existsByOsmRelationId(Long osmRelationId);

    @Query("SELECT r FROM RouteModel r " +
            "LEFT JOIN FETCH r.buses " +
            "LEFT JOIN FETCH r.stops " +
            "LEFT JOIN FETCH r.timeLines " +
            "LEFT JOIN FETCH r.ways " +
            "WHERE r.id = :routeId")
    Optional<RouteModel> findByIdWithAllRelations(@Param("routeId") UUID routeId);

    @Query("SELECT DISTINCT r FROM RouteModel r " +
            "LEFT JOIN FETCH r.buses " +
            "LEFT JOIN FETCH r.stops " +
            "LEFT JOIN FETCH r.timeLines " +
            "LEFT JOIN FETCH r.ways " +
            "WHERE r.routeName = :routeName")
    List<RouteModel> findByRouteNameWithAllRelations(@Param("routeName") String routeName);

    List<RouteModel> findByRouteNumber(String routeNumber);
}

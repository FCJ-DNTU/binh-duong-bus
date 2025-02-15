package fcj.dntu.vn.backend.dtos;

import java.util.UUID;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class WayDto {
    private UUID id;
    private String name;
    private Integer sequence;

    public WayDto(UUID id, String name, Integer sequence) {
        this.id = id;
        this.sequence = sequence;
    }
}

extends EntitySheet


# Enter rocket
func pickup(rover: Rover, entity: Entity) -> void:
	LevelSignals.enter_rocket()

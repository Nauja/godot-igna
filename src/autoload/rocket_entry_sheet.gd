# Configuration of the rocket entry
class_name RockerEntrySheet
extends EntitySheet


# Enter the rocket when rover moves over
func pickup(rover: Rover, entity: Entity) -> bool:
	LevelSignals.enter_rocket()
	return false

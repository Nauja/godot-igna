# Configuration of a power station
class_name PowerStationSheet
extends EntitySheet


# Fully charge the rover when picked up
func pickup(rover: Rover, entity: Entity) -> bool:
	rover.set_charging(true)
	return false

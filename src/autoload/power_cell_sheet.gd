# Configuration of a power cell
class_name PowerCellSheet
extends EntitySheet


# Add a charge to the power module when picked up by rover
func pickup(rover: Rover, entity: Entity) -> bool:
	rover.power_module.gain_charge()
	return true

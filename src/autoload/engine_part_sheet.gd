# Configuration of an engine part
class_name EnginePartSheet
extends EntitySheet


# Add a charge to the engine module when picked up by rover
func pickup(rover: Rover, entity: Entity) -> bool:
	rover.engine_module.gain_charge()
	return true

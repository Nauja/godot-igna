# Configuration of a fellow human
class_name FellowHumanSheet
extends EntitySheet

# Name of the human
@export_subgroup("EntitySheet")
@export var name: String


# Rescue the fellow human when picked up by rover
func pickup(rover: Rover, entity: Entity) -> bool:
	LevelSignals.notify_human_rescued(entity.entity_sheet)
	LevelSignals.enter_rover()
	return true

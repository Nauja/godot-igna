class_name FellowHumanSheet
extends EntitySheet

# Name of the human
@export_subgroup("EntitySheet")
@export var name: String


func pickup(rover: Rover, entity: Entity) -> void:
	entity.queue_free()
	LevelSignals.notify_human_rescued(entity.entity_sheet)
	RoverSignals.enter_rover()

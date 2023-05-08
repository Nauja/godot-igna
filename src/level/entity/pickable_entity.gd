# Make the parent entity pickable.
# The rover can move over the entity to pick it up
class_name PickableEntity
extends Node


func _ready():
	RoverSignals.rover_moved.connect(_on_rover_moved)


func _on_rover_moved() -> void:
	var entity = get_parent()
	if not entity or not entity.visible:
		return

	var rover = RoverSignals.rover
	if not rover:
		return

	if entity.map == rover.map and entity.tile == rover.tile:
		if entity.entity_sheet.pickup(rover, entity):
			entity.queue_free()

# Script to add to an entity to make it pickable
class_name PickableEntity
extends Node


func _ready():
	RoverSignals.rover_moved.connect(_on_rover_moved)


func _on_rover_moved() -> void:
	var entity = get_parent()
	if not entity:
		return

	var rover = RoverSignals.get_rover()
	if not rover:
		return

	if rover.tile == entity.tile:
		entity.entity_sheet.pickup(rover, entity)

class_name PowerStationSheet
extends EntitySheet


func pickup(rover: Rover, entity: Entity) -> void:
	rover.set_charging(true)

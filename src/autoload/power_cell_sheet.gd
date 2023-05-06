class_name PowerCellSheet
extends EntitySheet


func pickup(rover: Rover, entity: Entity) -> void:
	entity.queue_free()
	rover.power_module.gain_charge()

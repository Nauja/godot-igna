class_name EnginePartSheet
extends EntitySheet


func pickup(rover: Rover, entity: Entity) -> void:
	entity.queue_free()
	rover.engine_module.gain_charge()

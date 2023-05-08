# Configuration of a module of the rover
class_name ModuleSheet
extends EntitySheet

# What module it is
@export_subgroup("EntitySheet")
@export var module: Enums.EModule
# Maximum integrity level
@export var max_integrity: int
# Initial integrity level
@export var integrity: int
# Maximum charge level
@export var max_charge: int
# Initial charge level
@export var charge: int


# Open a dialogue on player interaction
func interact(player: Player, entity: Entity) -> void:
	if LevelSignals.is_dialogue_open():
		LevelSignals.close_dialogue()
	else:
		LevelSignals.open_dialogue()
		if entity.integrity == entity.max_integrity:
			LevelSignals.set_dialogue(entity, "ok")
		else:
			LevelSignals.set_dialogue(null, "fixing " + cursor_hint)
			entity.integrity = entity.max_integrity

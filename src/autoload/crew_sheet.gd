# Configuration of a crew member
class_name CrewSheet
extends EntitySheet

# Sheet of the fellow human
@export_subgroup("EntitySheet")
@export var _fellow_human_sheet: Resource
var fellow_human_sheet: FellowHumanSheet:
	get:
		return _fellow_human_sheet
# Dialogue when talked to
@export var dialogue: String


# Open a dialogue on player interaction
func interact(player: Player, entity: Entity) -> void:
	if LevelSignals.is_dialogue_open():
		LevelSignals.close_dialogue()
	else:
		LevelSignals.open_dialogue()
		LevelSignals.set_dialogue(entity, entity.entity_sheet.dialogue.replace("\\n", "\n"))

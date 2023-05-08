# Make the parent entity interactable.
# The play can press the action key to interact with the entity
class_name InteractableEntity
extends Node


func _ready():
	PlayerSignals.player_interact.connect(_on_player_interact)


func _on_player_interact() -> void:
	var entity = get_parent()
	if not entity or not entity.visible:
		return

	var player = PlayerSignals.get_player()
	if not player:
		return

	if entity.map == player.map and player.is_facing(entity):
		entity.entity_sheet.interact(player, entity)

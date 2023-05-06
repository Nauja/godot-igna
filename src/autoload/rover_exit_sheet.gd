extends EntitySheet


# Exit the rover on interaction
func interact(player: Player, entity: Entity) -> void:
	RoverSignals.exit_rover()

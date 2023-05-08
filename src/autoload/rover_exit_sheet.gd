# Configuration of the rover exit
class_name RoverExitSheet
extends EntitySheet


# Exit the rover on player interaction
func interact(player: Player, entity: Entity) -> void:
	LevelSignals.exit_rover()

extends Node

# initializes the player immediately allowing for every other node to easily access it
var Player = null

func change_level(New_level_path: PackedScene):
	if not New_level_path:
		return

	# Remove current scene (level)
	var Current_scene = get_tree().current_scene
	if Current_scene:
		Current_scene.queue_free()

	# Load new level
	var New_level = New_level_path.instantiate()
	if not New_level:
		return

	# Add new level to tree
	get_tree().root.add_child(New_level)
	get_tree().current_scene = New_level

	# Reparent player safely
	if Player:
		if Player.get_parent():
			Player.get_parent().remove_child(Player)  # Remove from previous level
		New_level.add_child(Player)  # Add to new level

		# Set player spawn position
		var Spawn = New_level.get_node_or_null("PlayerSpawn")
		if Spawn:
			Player.global_position = Spawn.global_position
		else:
			Player.global_position = Vector2(100, 100)

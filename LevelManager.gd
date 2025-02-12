extends Node

var player: CharacterBody2D = null

func change_level(new_level_path: PackedScene):
	if not new_level_path:
		print("Error: No level provided!")
		return

	# Remove current scene (level)
	var current_scene = get_tree().current_scene
	if current_scene:
		print("Removing current scene: ", current_scene.name)
		current_scene.queue_free()

	# Load new level
	var new_level = new_level_path.instantiate()
	if not new_level:
		print("Error: Failed to instantiate level!")
		return

	# Add new level to tree
	get_tree().root.add_child(new_level)
	get_tree().current_scene = new_level
	print("Loaded new level: ", new_level.name)

	# Reparent player safely
	if player:
		if player.get_parent():
			player.get_parent().remove_child(player)  # Remove from previous level
		new_level.add_child(player)  # Add to new level

		# Set player spawn position
		var spawn = new_level.get_node_or_null("PlayerSpawn")
		if spawn:
			print("Spawning player at: ", spawn.global_position)
			player.global_position = spawn.global_position
		else:
			print("No spawn found, using default position.")
			player.global_position = Vector2(100, 100)

extends Node

var player: CharacterBody2D = null

func change_level(new_level_path: PackedScene):
	if not new_level_path:
		return

	# Remove current scene (level)
	var current_scene = get_tree().current_scene
	if current_scene:
		current_scene.queue_free()

	# Load new level
	var new_level = new_level_path.instantiate()
	if not new_level:
		return

	# Add new level to tree
	get_tree().root.add_child(new_level)
	get_tree().current_scene = new_level

	# Reparent player safely
	if player:
		if player.get_parent():
			player.get_parent().remove_child(player)  # Remove from previous level
		new_level.add_child(player)  # Add to new level

		# Set player spawn position
		var spawn = new_level.get_node_or_null("PlayerSpawn")
		if spawn:
			player.global_position = spawn.global_position
		else:
			player.global_position = Vector2(100, 100)

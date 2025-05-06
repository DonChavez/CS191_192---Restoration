extends Control

func _ready():
	self.hide()  # Hide overlay initially

func show_game_over():
	self.show()
	get_tree().paused = true  # Pause the game when showing game over

func _on_restart_pressed() -> void:
	# Check if current level is Level0Final
	var current_scene = get_tree().current_scene
	if current_scene and current_scene.name == "The Tutorial":
		# Respawn player at PlayerSpawn
		var player_spawn = PlayerManager.Player_instance.get_parent().get_node_or_null("PlayerSpawn")
		if player_spawn and PlayerManager.Player_instance:
			PlayerManager.Player_instance.global_position = player_spawn.global_position
			# Reset player state (e.g., health) if needed
			if PlayerManager.Player_instance.has_method("reset_state"):
				PlayerManager.Player_instance.reset_state()
			# Hide game over screen and unpause
			self.hide()
			get_tree().paused = false
		else:
			push_error("PlayerSpawn or Player_instance not found in Level0Final")
			# Fallback to menu
			goto_menu()
	else:
		# For other levels, go to menu
		goto_menu()

func goto_menu():
	get_tree().paused = false  # Unpause the game
	get_tree().change_scene_to_file("res://Scenes/UI/Menu.tscn")

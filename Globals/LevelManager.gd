extends Node

var Starting_level = "res://Scenes/Levels/TestingArea/BaseTestingArea.tscn"

func start_game() -> void:
	if not Starting_level:
		push_error("Start level path is invalid!")
		return

	# ensure that the player is properly spawned
	if PlayerManager:
		PlayerManager.spawn_player()
	
	# change the level after spawning the player
	change_level(Starting_level)

func change_level(New_level_path: String) -> void:
	if not New_level_path:
		push_error("New level path is invalid!")
		return
	
	# remove the player from the current scene before switching
	if PlayerManager and PlayerManager.player_instance:
		PlayerManager.player_instance.get_parent().remove_child(PlayerManager.player_instance)
	get_tree().change_scene_to_file(New_level_path)
	
	# call the function after the scene has full loaded
	call_deferred("_deferred_transfer_player")

func _deferred_transfer_player() -> void:
	# wait for the previous function to finish
	await get_tree().process_frame
	
	# transfer the player to the current level
	if PlayerManager:
		PlayerManager.transfer_player()
	else:
		push_error("PlayerManager is not found!")

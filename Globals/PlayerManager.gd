extends Node

var player_scene_path: String = "res://Scenes/Player/Player.tscn"
var player_instance: Node = null  # the player instance

func spawn_player() -> void:
	# makes sure only 1 player exists
	if not player_instance:  
		var player_scene = load(player_scene_path) as PackedScene
		if player_scene:
			player_instance = player_scene.instantiate()
			get_tree().current_scene.add_child(player_instance)
		else:
			push_error("Player scene could not be loaded.")

	# spawn the player at the "PlayerSpawn Node
	var spawn = get_tree().current_scene.get_node_or_null("PlayerSpawn")
	if spawn:
		player_instance.global_position = spawn.global_position

func transfer_player() -> void:
	# wait for the previous call to finish
	await get_tree().process_frame  

	# get the current scene of the loaded level
	var new_scene = get_tree().current_scene
	if not new_scene:
		push_error("New scene is null! Cannot transfer player.")
		return

	if player_instance:
		# move player to the current loaded level
		new_scene.add_child(player_instance) 

		# spawn the player at the node called "PlayerSpawn"
		var spawn = new_scene.get_node_or_null("PlayerSpawn")
		if spawn:
			player_instance.global_position = spawn.global_position

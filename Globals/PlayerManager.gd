extends Node

var Player_scene_path: String = "res://Scenes/Player/Player.tscn"
var Player_instance: Node = null  # the player instance

func spawn_player() -> void:
	# makes sure only 1 player exists
	if not Player_instance:  
		var Player_scene = load(Player_scene_path) as PackedScene
		if Player_scene:
			Player_instance = Player_scene.instantiate()
			get_tree().current_scene.add_child(Player_instance)
		else:
			push_error("Player scene could not be loaded.")

	# spawn the player at the "PlayerSpawn Node
	var Spawn = get_tree().current_scene.get_node_or_null("PlayerSpawn")
	if Spawn:
		Player_instance.global_position = Spawn.global_position

func transfer_player() -> void:
	# wait for the previous call to finish
	await get_tree().process_frame  

	# get the current scene of the loaded level
	var New_scene = get_tree().current_scene
	if not New_scene:
		push_error("New scene is null! Cannot transfer player.")
		return

	if Player_instance:
		# move player to the current loaded level
		New_scene.add_child(Player_instance) 

		# spawn the player at the node called "PlayerSpawn"
		var Spawn = New_scene.get_node_or_null("PlayerSpawn")
		if Spawn:
			Player_instance.global_position = Spawn.global_position
			
func disable_player_input() -> void:
	Player_instance.Can_process_input = false

func enable_player_input() -> void:
	Player_instance.Can_process_input = true
	
func disable_player_movement() -> void:
	Player_instance.Can_process_input = false
	
func enable_player_movement() -> void:
	Player_instance.Can_process_input = false

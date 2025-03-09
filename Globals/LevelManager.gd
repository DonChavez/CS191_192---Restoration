extends Node

var Starting_level = "res://Scenes/Levels/TestingArea/BaseTestingArea.tscn"

# Signals for better control and debugging
signal load_start()
signal load_complete()

var _Loading_in_progress: bool = false  # prevent concurrent loading
var _New_scene_path: String = ""  # Store the path of the new scene

func start_game() -> void:
	if not Starting_level:
		push_error("Start level path is invalid!")
		return

	# Ensure the player is properly spawned
	if PlayerManager:
		PlayerManager.spawn_player()
	
	# Change the level after spawning the player
	change_level(Starting_level)

func change_level(New_level_path: String) -> void:
	if not New_level_path:
		push_error("New level path is invalid!")
		return
	
	if _Loading_in_progress:
		push_warning("LevelManager is already loading a level!")
		return
	
	# change state
	_Loading_in_progress = true
	_New_scene_path = New_level_path
	
	# Remove the player from the current scene before switching
	if PlayerManager and PlayerManager.Player_instance:
		if PlayerManager.Player_instance.is_inside_tree():
			PlayerManager.Player_instance.get_parent().remove_child(PlayerManager.Player_instance)
			print("Player removed from scene tree")
	
	# emit load_start for transition in the future
	load_start.emit()
	
	# load the new scene using ResourceLoader
	var loader = ResourceLoader.load_threaded_request(New_level_path)
	if not ResourceLoader.exists(New_level_path) or loader == null:
		push_error("Invalid level path: %s" % New_level_path)
		_Loading_in_progress = false
		return
	
	# monitor the load status every 0.1 seconds
	var Load_progress_timer = Timer.new()
	Load_progress_timer.wait_time = 0.1
	Load_progress_timer.timeout.connect(_monitor_load_status.bind(Load_progress_timer))
	get_tree().root.add_child(Load_progress_timer)
	Load_progress_timer.start()

func _monitor_load_status(timer: Timer) -> void:
	# runs every {wait_time} to check the load status of the scene
	var Load_progress = []
	var Load_status = ResourceLoader.load_threaded_get_status(_New_scene_path, Load_progress)

	# load_status handler
	match Load_status:
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			push_error("Invalid resource: %s" % _New_scene_path)
			timer.stop()
			timer.queue_free()
			_Loading_in_progress = false
			return
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			# to see load progress
			print("Loading progress: ", Load_progress[0] * 100, "%")
		ResourceLoader.THREAD_LOAD_FAILED:
			push_error("Failed to load resource: %s" % _New_scene_path)
			timer.stop()
			timer.queue_free()
			_Loading_in_progress = false
			return
		ResourceLoader.THREAD_LOAD_LOADED:
			timer.stop()
			timer.queue_free()
			# Instantiate and handle the loaded scene
			var new_scene = ResourceLoader.load_threaded_get(_New_scene_path).instantiate()
			_on_level_loaded(new_scene)
			return

func _on_level_loaded(New_scene: Node) -> void:
	# remove the old scene
	var Old_scene = get_tree().current_scene
	if Old_scene and Old_scene != get_tree().root:
		Old_scene.queue_free()
	
	# add the new scene to the tree and set it as current
	get_tree().root.add_child(New_scene)
	get_tree().current_scene = New_scene
	
	# transfer the player to the new scene with its position pre-set
	if PlayerManager:
		PlayerManager.transfer_player()
	else:
		push_error("PlayerManager is not found!")
	
	# reset state
	_Loading_in_progress = false
	_New_scene_path = ""
	
	# future use for transitions
	load_complete.emit()

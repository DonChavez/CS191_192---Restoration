extends Node

var Starting_level = "res://Scenes/Levels/TestingArea/HubTestingArea.tscn" # changed starting area

# Signals for better control and debugging
signal load_start()
signal load_complete()

var _Loading_in_progress: bool = false  # prevent concurrent loading
var _New_scene_path: String = ""  # Store the path of the new scene
var current_level_name: String = ""

func start_game() -> void:
	if not Starting_level:
		push_error("Start level path is invalid!")
		return
	
	# Load the first level immediately without a transition
	_start_level_load_direct(Starting_level)
	AudioManager.play_sound("forest_theme")

func _start_level_load_direct(New_level_path: String) -> void:
	# Ensure the path is valid
	if not ResourceLoader.exists(New_level_path):
		push_error("Invalid level path: %s" % New_level_path)
		return

	# Remove the old scene before loading the new one
	var Old_scene = get_tree().current_scene
	if Old_scene and Old_scene != get_tree().root:
		Old_scene.queue_free()

	# Load and instantiate the new scene
	var new_scene = load(New_level_path).instantiate()
	get_tree().root.add_child(new_scene)
	get_tree().current_scene = new_scene
	
	# set name
	current_level_name = new_scene.name

	# Spawn the player after the new scene is loaded
	if PlayerManager:
		PlayerManager.spawn_player()
	else:
		push_error("PlayerManager is not found!")
		
	# spawn the hud
	if UIManager:
		UIManager.init_ui()
	else:
		push_error("UIManager is not found!")

	# Reset loading state
	_Loading_in_progress = false
	_New_scene_path = ""
	
	# Emit completion signal
	load_complete.emit()

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
	
	# Start the transition effect before loading
	if Transition:
		Transition.play_transition(Callable(self, "_start_level_load"))
	else:
		_start_level_load()
	
	PlayerManager.disable_player()

func _start_level_load() -> void:
	# Remove the player from the current scene before switching
	if PlayerManager and PlayerManager.Player_instance:
		if PlayerManager.Player_instance.is_inside_tree():
			PlayerManager.Player_instance.get_parent().remove_child(PlayerManager.Player_instance)
			print("Player removed from scene tree")
			
	var loader = ResourceLoader.load_threaded_request(_New_scene_path)
	if not ResourceLoader.exists(_New_scene_path) or loader == null:
		push_error("Invalid level path: %s" % _New_scene_path)
		_Loading_in_progress = false
		return
	
	PlayerManager.enable_player()
	
	# Monitor the load status every 0.1 seconds
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
			print("LevelManager: Calling _on_level_loaded() with", _New_scene_path)
			_on_level_loaded(new_scene)

			return

func _on_level_loaded(New_scene: Node) -> void:
	current_level_name = New_scene.name

	# Remove the old scene
	var Old_scene = get_tree().current_scene
	if Old_scene and Old_scene != get_tree().root:
		Old_scene.queue_free()
	
	# Add the new scene and set it as current
	get_tree().root.add_child(New_scene)
	get_tree().current_scene = New_scene
	
	# Find UIManager and reinitialize it
	var ui_manager = get_tree().get_first_node_in_group("UIManager")
	if ui_manager:
		print("LevelManager: Calling UIManager._on_level_loaded()")
		ui_manager._on_level_loaded()
	else:
		print("LevelManager: UIManager not found!")

	# Transfer the player to the new scene with its position pre-set
	if PlayerManager:
		PlayerManager.transfer_player()
	else:
		push_error("PlayerManager is not found!")

	# Reset state
	_Loading_in_progress = false
	_New_scene_path = ""

	# Emit the level load complete signal
	load_complete.emit()
	
func get_current_level_name() -> String:
	return current_level_name

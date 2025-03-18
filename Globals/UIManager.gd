extends Node

# HUD VARIABLES
var LevelName: Label
var PlayerInfoUI: Node
var PollutionLevelUI: ProgressBar

# local variables
var Initialized: bool = false

func init_ui() -> void:
	# to prevent multiple calls
	if Initialized:
		return
	Initialized = true

	print("UIManager initializing...")
	add_to_group("UIManager")
	
	# connect load_complete signal to know if level is fully loaded
	if LevelManager and not LevelManager.load_complete.is_connected(_on_level_loaded):
		LevelManager.load_complete.connect(_on_level_loaded)

	reinitialize_ui()

# Reload UI
func reinitialize_ui() -> void:
	call_deferred("_initialize_UI_elements")

# init the HUD
func _initialize_UI_elements() -> void:
	await get_tree().process_frame
	_update_player()
	_update_hud()
	_update_pollution_manager()
	_update_level_name()

func _update_player() -> void:
	var player = PlayerManager.Player_instance

	if not player:
		await PlayerManager.Player_spawned
		player = PlayerManager.Player_instance
	
	if not player:
		push_error("Still couldn't find player instance!")
		return

func _update_hud() -> void:
	var player = PlayerManager.Player_instance
	if not player:
		return

	var ui_wrapper = player.get_node_or_null("UI Wrapper")
	if not ui_wrapper:
		push_error("UIWrapper not found in Player!")
		return

	var hud = ui_wrapper.get_node_or_null("HUD")
	if not hud:
		push_error("HUD not found inside UIWrapper!")
		return

	# HUD elements to be updated
	LevelName = hud.get_node_or_null("Top/Header/Timer/HBoxContainer/LevelName")
	PlayerInfoUI = hud.get_node_or_null("PlayerInfo")
	PollutionLevelUI = hud.get_node_or_null("Top/Header/PollutionSystem/PollutionLevel")

	if not PlayerInfoUI:
		push_error("PlayerInfo not found!")
	if not PollutionLevelUI:
		push_error("PollutionLevel ProgressBar not found!")
		return

	if PlayerInfoUI.has_method("_initialize_UI_elements"):
		PlayerInfoUI._initialize_UI_elements()

# sync pollution meter with pollution manager
func _update_pollution_manager() -> void:
	var pollution_manager = get_tree().get_first_node_in_group("PollutionManager")
	if pollution_manager and not pollution_manager.is_connected("pollution_updated", _update_pollution_ui):
		pollution_manager.pollution_updated.connect(_update_pollution_ui)
		
# sync pollution to progress bar
func _update_pollution_ui(value: float) -> void:
	if PollutionLevelUI:
		PollutionLevelUI.value = value

# sync level name to the scene name
func _update_level_name() -> void:
	if not LevelName:
		print("LevelName is null. Attempting to reinitialize UI...")
		await get_tree().process_frame
		await get_tree().process_frame
		reinitialize_ui()
		if not LevelName:
			push_error("LevelName label still not found in UI!")
			return

	if LevelManager and LevelManager.current_level_name:
		LevelName.text = LevelManager.current_level_name
	else:
		LevelName.text = "Unknown Level"

	print("Updated Level Name to: ", LevelName.text)

# reload the hud after scene load
func _on_level_loaded() -> void:
	print("Reinitializing UIManager after level load")
	_update_level_name()
	reinitialize_ui()

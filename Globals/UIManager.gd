extends Node

# HUD VARIABLES
var LevelName: Label
var PlayerInfoUI: Node
var PollutionLevelUI: ProgressBar

# local variables
var Initialized: bool = false

func init_ui() -> void:
	if Initialized:
		return
	Initialized = true

	print("UIManager initializing...")
	add_to_group("UIManager")
	
	if LevelManager and not LevelManager.load_complete.is_connected(_on_level_loaded):
		LevelManager.load_complete.connect(_on_level_loaded)
	
	if PlayerManager and not PlayerManager.Player_spawned.is_connected(_on_player_spawned):
		PlayerManager.Player_spawned.connect(_on_player_spawned)

	# Initial setup
	await get_tree().process_frame
	reinitialize_ui()

# Reload UI
func reinitialize_ui() -> void:
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

	# Reassign HUD elements
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

# Sync pollution meter with pollution manager
func _update_pollution_manager() -> void:
	var pollution_manager = get_tree().get_first_node_in_group("PollutionManager")
	if pollution_manager and not pollution_manager.is_connected("pollution_updated", _update_pollution_ui):
		pollution_manager.pollution_updated.connect(_update_pollution_ui)

# Sync pollution to progress bar
func _update_pollution_ui(value: float) -> void:
	if PollutionLevelUI and is_instance_valid(PollutionLevelUI):
		PollutionLevelUI.value = value

# Sync level name to the scene name
func _update_level_name() -> void:
	var level_name_text: String = "Unknown Level"  # Default value
	
	if LevelManager and LevelManager.current_level_name:
		level_name_text = LevelManager.current_level_name
	
	if LevelName and is_instance_valid(LevelName):
		LevelName.text = level_name_text
		print("Updated Level Name to: ", level_name_text)
	else:
		print("LevelName not ready yet, defaulting to: ", level_name_text)

# Reload the HUD after scene load
func _on_level_loaded() -> void:
	print("Reinitializing UIManager after level load")
	reinitialize_ui()

# Reinitialize UI when a new player spawns
func _on_player_spawned() -> void:
	print("Player spawned, reinitializing UI elements")
	reinitialize_ui()

extends Node

## Signals
signal Player_died
signal Player_spawned  # Emitted when the player is successfully spawned

## Player Instance Variables
var Player_scene_path: String = "res://Scenes/Player/Player.tscn"
var Player_instance: Node = null : set = _set_player_instance

# Audio variables
var spawn_sfx: AudioStreamPlayer  # Will be created in _ready
@export var spawn_sound: AudioStream = preload("res://Music/SFX/Player/spawn.mp3")
@export var block_sound: AudioStream = preload("res://Music/SFX/Player/block_1.mp3")
const TELEPORT_END = preload("res://Music/SFX/Player/Teleport_end.mp3")

func _ready():
	spawn_sfx = AudioStreamPlayer.new()
	spawn_sfx.name = "SpawnSFX"
	add_child(spawn_sfx)
	
func play_block_sfx():
	if spawn_sfx and block_sound:
		spawn_sfx.stream = block_sound
		spawn_sfx.play()
	
## Player Instance Setter
func _set_player_instance(value: Node) -> void:
	Player_instance = value
	if Player_instance:
		Player_spawned.emit()

## Player Spawning & Transferring
func spawn_player() -> void:
	if Player_instance:
		return  # Prevent multiple spawns

	var Player_scene = load(Player_scene_path) as PackedScene
	if not Player_scene:
		push_error("Player scene could not be loaded.")
		return

	Player_instance = Player_scene.instantiate()
	get_tree().current_scene.add_child(Player_instance)
	
	# Play spawn sound
	if spawn_sfx and spawn_sound:
		spawn_sfx.stream = spawn_sound
		spawn_sfx.play()
	
	_initialize_player_position()
	_connect_health_signal()

func transfer_player() -> void:
	await get_tree().process_frame  # Ensure previous calls complete
	
	if spawn_sfx:
		spawn_sfx.stream = TELEPORT_END
		spawn_sfx.play()

	var New_scene = get_tree().current_scene
	if not New_scene:
		push_error("New scene is null! Cannot transfer player.")
		return

	if Player_instance:
		var pollute = Player_instance.get_node_or_null("UI Wrapper/HUD/Top/Header/PollutionSystem")
		pollute.Current_pollution = pollute.Max_pollution
		New_scene.add_child(Player_instance)
		_initialize_player_position()
		
		
	if spawn_sfx:
		spawn_sfx.stream = TELEPORT_END
		spawn_sfx.play()

## Player Initialization
func _initialize_player_position() -> void:
	var Spawn = get_tree().current_scene.get_node_or_null("PlayerSpawn")
	if Spawn:
		Player_instance.global_position = Spawn.global_position
		Player_spawned.emit()

func _connect_health_signal() -> void:
	var health_component = Player_instance.get_node_or_null("PlayerHealth")
	if health_component and health_component.has_signal("died"):
		health_component.died.connect(_on_player_died)
	else:
		push_error("HealthComponent is missing or has no 'died' signal!")

## Player State Control
func disable_player() -> void:
	if Player_instance:
		Player_instance.set_physics_process(false)
		disable_player_collisions()
		_toggle_hud(false)

func enable_player() -> void:
	if Player_instance:
		Player_instance.set_physics_process(true)
		enable_player_collisions()
		_toggle_hud(true)

func disable_player_input() -> void:
	if Player_instance:
		Player_instance.Can_process_input = false

func enable_player_input() -> void:
	if Player_instance:
		Player_instance.Can_process_input = true

func disable_player_movement() -> void:
	disable_player_input()  # Movement and input are tied

func enable_player_movement() -> void:
	enable_player_input()

## Collision Management
func disable_player_collisions() -> void:
	if Player_instance:
		for child in Player_instance.get_children():
			if child is CollisionShape2D:
				child.set_deferred("disabled", true)

func enable_player_collisions() -> void:
	if Player_instance:
		for child in Player_instance.get_children():
			if child is CollisionShape2D:
				child.set_deferred("disabled", false)

## HUD Management
func _toggle_hud(visible: bool) -> void:
	var hud = Player_instance.get_node_or_null("UI Wrapper")
	if hud:
		hud.visible = visible

## Player Death Handling
func _on_player_died() -> void:
	print("Player has died!")
	Player_died.emit()

	get_tree().paused = true  # Pause game
	_show_game_over_screen(Player_instance)

func _show_game_over_screen(player: Node) -> void:
	if not player:
		return

	var ui_wrapper = player.get_node_or_null("UI Wrapper")
	if not ui_wrapper:
		return

	var game_over_screen = ui_wrapper.get_node_or_null("GameOverScreen")
	if game_over_screen:
		game_over_screen.show()
		return

	# Instantiate Game Over screen if missing
	game_over_screen = preload("res://Scenes/UI/GameOverScreen.tscn").instantiate()
	game_over_screen.name = "GameOverScreen"
	ui_wrapper.add_child(game_over_screen)
	game_over_screen.show_game_over()

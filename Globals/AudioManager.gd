extends Node

# Preloaded sound effects
var sounds: Dictionary = {
	"trash_pickup": preload("res://Music/SFX/trash_pickup.mp3"),
	"coin_pickup": preload("res://Music/SFX/coin.mp3"),
	"teleport_start": preload("res://Music/SFX/Player/Teleport_start.mp3"),
	"forest_theme": preload("res://Music/OST/forest_theme_copyrighted.mp3")
}

# Pool of AudioStreamPlayer nodes to reuse
var audio_pool: Array[AudioStreamPlayer] = []
@export var pool_size: int = 10  # Number of players to pre-create

func _ready() -> void:
	# Initialize the audio pool
	for i in range(pool_size):
		var player = AudioStreamPlayer.new()
		player.finished.connect(_on_audio_finished.bind(player))
		add_child(player)
		audio_pool.append(player)

# Play a sound by name (non-positional)
func play_sound(sound_name: String) -> void:
	if sound_name in sounds:
		var player = _get_available_player()
		if player:
			player.stream = sounds[sound_name]
			player.play()

# Play a positional sound at a specific global position (2D)
func play_sound_at_position(sound_name: String, position: Vector2) -> void:
	if sound_name in sounds:
		var player_2d = AudioStreamPlayer2D.new()
		player_2d.stream = sounds[sound_name]
		player_2d.global_position = position
		player_2d.finished.connect(_on_audio_finished_2d.bind(player_2d))
		get_tree().root.add_child(player_2d)  # Add to root to persist after caller is freed
		player_2d.play()

# Play a positional sound with panning based on direction
func play_sound_with_panning(sound_name: String, position: Vector2, direction: String) -> void:
	if sound_name in sounds:
		var player_2d = AudioStreamPlayer2D.new()
		player_2d.stream = sounds[sound_name]
		player_2d.global_position = position
		match direction:
			"left":
				player_2d.pan = -0.3
			"right":
				player_2d.pan = 0.3
			"up":
				player_2d.pan = 0.0
				player_2d.volume_db = -3.0
			"down":
				player_2d.pan = 0.0
				player_2d.volume_db = 0.0
		player_2d.finished.connect(_on_audio_finished_2d.bind(player_2d))
		get_tree().root.add_child(player_2d)
		player_2d.play()

# Get an available AudioStreamPlayer from the pool
func _get_available_player() -> AudioStreamPlayer:
	for player in audio_pool:
		if not player.playing:
			return player
	# If no available player, create a new one (optional)
	var new_player = AudioStreamPlayer.new()
	new_player.finished.connect(_on_audio_finished.bind(new_player))
	add_child(new_player)
	audio_pool.append(new_player)
	return new_player

# Cleanup for non-positional players
func _on_audio_finished(player: AudioStreamPlayer) -> void:
	player.stream = null  # Clear stream to mark as available

# Cleanup for positional players
func _on_audio_finished_2d(player_2d: AudioStreamPlayer2D) -> void:
	player_2d.queue_free()  # Free the node after it finishes

func stop_all() -> void:
	# Stop all non-positional players in the pool
	for player in audio_pool:
		if player.playing:
			player.stop()

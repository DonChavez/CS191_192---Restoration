extends Control

signal game_paused
signal game_resumed

@onready var continue_button: Button = $Continue
@onready var quit_button: Button = $Quit

func _ready() -> void:
	hide()
	continue_button.mouse_entered.connect(_on_button_hovered)
	quit_button.mouse_entered.connect(_on_button_hovered)

func toggle_pause() -> void:
	if get_tree().paused:
		resume_game()
	else:
		pause_game()

func pause_game() -> void:
	show()
	get_tree().paused = true
	game_paused.emit()

func resume_game() -> void:
	hide()
	get_tree().paused = false
	game_resumed.emit()

func _on_quit_pressed() -> void:
	get_tree().paused = false  # Unpause the game
	get_tree().quit()

func _on_continue_pressed() -> void:
	resume_game()
	
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer	

@export var hover_sounds: Array[AudioStream] = [
	preload("res://Music/SFX/UI/Modern6.mp3"),
	preload("res://Music/SFX/UI/Modern7.mp3"),
	preload("res://Music/SFX/UI/Modern5.mp3"),
	preload("res://Music/SFX/UI/Modern4.mp3")
]

func _on_button_hovered() -> void:
	if audio_player and hover_sounds.size() > 0:
		var random_sound = hover_sounds[randi() % hover_sounds.size()]
		audio_player.stream = random_sound
		audio_player.play()

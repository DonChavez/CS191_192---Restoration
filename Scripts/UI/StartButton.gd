extends CanvasLayer

@export var hover_sounds: Array[AudioStream] = [
	preload("res://Music/SFX/UI/Modern6.mp3"),
	preload("res://Music/SFX/UI/Modern7.mp3"),
	preload("res://Music/SFX/UI/Modern5.mp3"),
	preload("res://Music/SFX/UI/Modern4.mp3")
]

@export var pressed_sound: AudioStream = preload("res://Music/SFX/UI/Modern10.mp3")

@onready var continue_button: Button = $Menu/Continue
@onready var new_game_button: Button = $"Menu/New Game"
@onready var exit_button: Button = $Menu/Exit
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer


func _ready() -> void:
	# Connect hover signals for each button
	continue_button.mouse_entered.connect(_on_button_hovered)
	new_game_button.mouse_entered.connect(_on_button_hovered)
	exit_button.mouse_entered.connect(_on_button_hovered)

# when start button is pressed, start the game
func _on_continue_pressed() -> void:
	audio_player.stream = pressed_sound
	audio_player.play()
	LevelManager.start_game()

func _on_new_game_pressed() -> void:
	audio_player.stream = pressed_sound
	audio_player.play()
	LevelManager.start_game()
	
func _on_exit_pressed() -> void:
	audio_player.stream = pressed_sound
	audio_player.play()
	get_tree().quit()
	
func _on_button_hovered() -> void:
	if audio_player and hover_sounds.size() > 0:
		var random_sound = hover_sounds[randi() % hover_sounds.size()]
		audio_player.stream = random_sound
		audio_player.play()

extends CanvasLayer

@onready var pause_screen = $PauseScreen
var game_over = false

func _ready() -> void:
	if PlayerManager:
		PlayerManager.Player_died.connect(_on_player_died)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape") and not game_over:
		pause_screen.toggle_pause()

func _on_player_died() -> void:
	game_over = true  # Prevent pausing on game over
	pause_screen.resume_game()  # Ensure game is unpaused when game over happens

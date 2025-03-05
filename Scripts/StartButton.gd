extends Control

# when start button is pressed, start the game
func _on_button_pressed() -> void:
	LevelManager.start_game()

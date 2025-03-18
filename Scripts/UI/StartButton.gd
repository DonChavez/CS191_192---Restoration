extends CanvasLayer

# when start button is pressed, start the game
func _on_continue_pressed() -> void:
	LevelManager.start_game()

func _on_new_game_pressed() -> void:
	LevelManager.start_game()
	
func _on_exit_pressed() -> void:
	get_tree().quit()

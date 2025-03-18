extends Control

signal game_paused
signal game_resumed

func _ready() -> void:
	hide()

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
	get_tree().change_scene_to_file("res://Scenes/UI/Menu.tscn")

func _on_continue_pressed() -> void:
	resume_game()

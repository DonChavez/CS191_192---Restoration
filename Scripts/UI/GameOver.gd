extends Control

func _ready():
	self.hide()  # Hide overlay initially

func show_game_over():
	self.show()

func _on_restart_pressed() -> void:
	get_tree().paused = false  # Unpause the game
	AudioManager.stop_all()
	get_tree().change_scene_to_file("res://Scenes/UI/Menu.tscn")

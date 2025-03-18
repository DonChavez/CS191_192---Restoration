extends CanvasLayer

@onready var game_over_screen = $"."

func _ready():
	game_over_screen.hide()  # Hide overlay initially

func show_game_over():
	game_over_screen.show()  # Show overlay

func _on_restart_button_pressed():
	get_tree().reload_current_scene()  # Reload current scene


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/Menu.tscn")

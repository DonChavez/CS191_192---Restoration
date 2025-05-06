extends Area2D

@export var Target_level_path: String = "res://Scenes/Levels/Level0/Level0Part1.tscn" # change accordingly

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	#if body.is_in_group("Player"):
		#print("Player moved to next scene!")
		#LevelManager.change_level(Target_level_path)
	LevelManager.change_level(Target_level_path)

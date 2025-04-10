extends Area2D

@export var Target_level_path: String = "res://Scenes/Levels/TestingArea/BaseTestingArea.tscn"
# will have to fix this to become automatic
 
@onready var Prompt_label = $Label
@onready var Animated_sprite = $Sprite2D

var Player_nearby = false

func _ready():
	Prompt_label.visible = false
	
func interact() -> void:
	print("Interacted with portalt!")  
	AudioManager.play_sound("teleport_start")
	# needed to change the scene
	LevelManager.change_level(Target_level_path)
		
func _process(_delta: float) -> void:
	if Player_nearby and Input.is_action_just_pressed("interact"):
		interact()
		
func _on_body_entered(_body: Node) -> void:
	Player_nearby = true
	Prompt_label.visible = true

func _on_body_exited(_body: Node2D) -> void:
	Player_nearby = false
	Prompt_label.visible = false 

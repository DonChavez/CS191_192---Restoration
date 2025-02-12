extends Area2D

@export var target_level_path: String = "res://Levels/Level_0.tscn"
 
@onready var prompt_label = $Label
@onready var animated_sprite = $Sprite2D

var player_nearby = false
var target_level: PackedScene

func _ready():
	prompt_label.visible = false
	target_level = load(target_level_path) as PackedScene
	
func interact() -> void:
	LevelManager.change_level(target_level)
		
func _process(_delta: float) -> void:
	if player_nearby and Input.is_action_just_pressed("interact"):
		interact()
		
func _on_body_entered(_body: Node) -> void:
	player_nearby = true
	prompt_label.visible = true

func _on_body_exited(_body: Node2D) -> void:
	player_nearby = false
	prompt_label.visible = false 

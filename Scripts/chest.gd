extends StaticBody2D

@onready var panel = $Panel
@onready var label = $Label
@onready var animated_sprite = $AnimatedSprite2D
@onready var inventory_manager = %InventoryManager

var player_nearby = false

func _ready():
	panel.visible = false
	label.visible = false
	

func interact() -> void:
	panel.visible = !panel.visible
	
		
func _process(_delta: float) -> void:
	if player_nearby and Input.is_action_just_pressed("interact"):
		interact()



func _on_area_2d_body_entered(_body: Node2D) -> void:
	player_nearby = true
	label.visible = true


func _on_area_2d_body_exited(_body: Node2D) -> void:
	player_nearby = false
	label.visible = false 
	panel.visible = false

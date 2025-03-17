extends CharacterBody2D

@onready var Sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var Dialogue: Control = $Dialogue
@onready var Guide: Label = $Label

var can_interact: bool = false  # Tracks if the player is in the interaction area

func _ready():
	Sprite.play("default")
	Dialogue.visible = false
	Guide.visible = false
	
func _physics_process(_delta):
	if can_interact and Input.is_action_just_pressed("interact"):  # Check if 'F' key is pressed
		Dialogue.visible = !Dialogue.visible  # Toggle visibility
		Guide.visible = !Guide.visible
		
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):  # Ensure only the player triggers it
		can_interact = true
		Guide.visible = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		can_interact = false
		Guide.visible = false
		Dialogue.visible = false  # Hide dialogue when leaving

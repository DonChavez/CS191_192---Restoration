extends Area2D

@export var interaction_sound: AudioStreamPlayer2D  
@onready var prompt_label = $Label
@onready var animated_sprite = $AnimatedSprite2D

var player_nearby = false

func _ready():
	prompt_label.visible = false
	animated_sprite.play("spin")

func interact() -> void:
	print("Interacted with the object!")  
	interaction_sound.play()  
		
func _process(_delta: float) -> void:
	if player_nearby and Input.is_action_just_pressed("interact"):
		interact()

func _on_body_entered(_body: Node) -> void:
	player_nearby = true
	prompt_label.visible = true

func _on_body_exited(_body: Node2D) -> void:
	player_nearby = false
	prompt_label.visible = false 

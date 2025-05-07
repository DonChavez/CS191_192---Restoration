extends CharacterBody2D

@onready var Sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var Guide: Label = $Label

@export var Dialogue_resource: DialogueResource
@export var Dialogue_start: String = ""
@export var TalkTuah: bool = false

var can_interact: bool = false
var player: Node2D

func _ready():
	Sprite.play("default")
	Guide.visible = false
	# Ensure unique ShaderMaterial for this instance
	if Sprite.material:
		Sprite.material = Sprite.material.duplicate()
	set_glow(false)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	add_to_group("NPC")

func _physics_process(_delta):
	if can_interact and Input.is_action_just_pressed("interact") and not DialogueState.is_dialogue_active:
		DialogueState.is_dialogue_active = true
		Guide.visible = false
		DialogueManager.show_example_dialogue_balloon(Dialogue_resource, Dialogue_start)
		if player:
			player.Can_process_input = false
			player.Can_process_movement = false
			player.HUD.visible = false
			TalkTuah = true
			set_glow(false)

func _on_dialogue_ended(_resource: DialogueResource):
	DialogueState.is_dialogue_active = false
	Guide.visible = can_interact
	if player:
		player.HUD.visible = true
		player.Can_process_input = true
		player.Can_process_movement = true
	set_glow(false)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		can_interact = true
		Guide.visible = true
		player = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		can_interact = false
		Guide.visible = false
		DialogueState.is_dialogue_active = false
		if player:
			player.Can_process_input = true
			player.Can_process_movement = true
			player.HUD.visible = true
		player = null

func set_glow(enabled: bool) -> void:
	if Sprite.material:
		Sprite.material.set_shader_parameter("glow_intensity", 1.0 if enabled else 0.0)

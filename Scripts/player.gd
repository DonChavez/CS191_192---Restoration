extends CharacterBody2D

@export var move_speed: float = 100
@export var attack_animation_speed: float = 0.1 
@export var sprite: Sprite2D

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var health_component = $HealthComponent

var attack_direction = Vector2.ZERO 
var is_attacking = false
var attack_duration = 0.5 
var attack_timer = 0.0
var facing_direction = Vector2.RIGHT 

func _ready():
	update_animation_parameters(Vector2(-1, 0))

func _physics_process(_delta: float):
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	).normalized()
	
	var mouse_position = get_global_mouse_position()
	facing_direction = (mouse_position - global_position).normalized()

	
	velocity = input_direction * move_speed
	move_and_collide(velocity * _delta)

	if is_attacking:
		update_animation_parameters(facing_direction)
		attack_timer += _delta
		if attack_timer >= attack_duration:
			is_attacking = false
			attack_timer = 0.0
			pick_new_state()

	if not is_attacking:
		update_animation_parameters(input_direction)
		pick_new_state()

func update_animation_parameters(move_input: Vector2):
	if move_input != Vector2.ZERO:
		animation_tree.set("parameters/Idle/blend_position", move_input)
		animation_tree.set("parameters/Walking/blend_position", move_input)

func pick_new_state():
	if Input.is_action_just_pressed("attack") and not is_attacking:
		is_attacking = true
		state_machine.travel("Attack")
		play_attack_animation(facing_direction) 
	elif velocity != Vector2.ZERO and not is_attacking:
		state_machine.travel("Walking")
	else:
		state_machine.travel("Idle")

func play_attack_animation(_attack_direction):
	print("Attack")
	animation_tree.set("parameters/Attack/blend_position", _attack_direction) 

func _on_health_component_died() -> void:
	print("Player is dead")
	
	var hurtbox = $HurtboxComponent
	if hurtbox and hurtbox.interaction_sound:
		hurtbox.interaction_sound.play()
		await get_tree().create_timer(0.3).timeout
	queue_free()

func _on_hurtbox_component_damaged(_amount: float) -> void:
	if sprite:
		sprite.modulate = Color(1, 0, 0)  
		await get_tree().create_timer(0.2).timeout
		sprite.modulate = Color(1, 1, 1)

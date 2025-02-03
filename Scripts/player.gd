extends CharacterBody2D

@export var move_speed: float = 100
@export var attack_animation_speed: float = 0.1 

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var health_component = $HealthComponent

var attack_direction = Vector2.ZERO 

func _ready():
	update_animation_parameters(Vector2(-1, 0))

func _physics_process(_delta: float):
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	).normalized()
	update_animation_parameters(input_direction)
	
	velocity = input_direction * move_speed
	
	move_and_collide(velocity * _delta)
	
	if Input.is_action_just_pressed("attack"):
		attack_direction = (get_global_mouse_position() - global_position).normalized() 
		play_attack_animation(input_direction)

	pick_new_state()

func update_animation_parameters(move_input: Vector2):
	if move_input != Vector2.ZERO:
		animation_tree.set("parameters/Idle/blend_position", move_input)
		animation_tree.set("parameters/Walking/blend_position", move_input)

func pick_new_state():
	if velocity != Vector2.ZERO:
		state_machine.travel("Walking")
	else:
		state_machine.travel("Idle")

func play_attack_animation(_attack_direction):
	print("Attack")
	state_machine.travel("Attack")
	animation_tree.set("parameters/Walking/blend_position", _attack_direction)


func _on_health_component_died() -> void:
	print("Player is dead")

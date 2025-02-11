extends CharacterBody2D

@export var move_speed: float = 100
@export var attack_animation_speed: float = 0.1
@export var projectile = load("res://Scenes/Projectile.tscn")
@export var dash_speed: float = 300
@export var dash_duration: float = 0.3
@export var dash_cooldown: float = 1.0
@export var is_invulnerable = false

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var health_component = $HealthComponent
@onready var inventory_manager = %InventoryManager
@onready var shield = $Shield
@onready var melee_hitbox = $MeleeHitbox
@onready var sprite = $Sprite2D
@onready var main = get_tree().current_scene

var attack_direction = Vector2.ZERO
var is_attacking = false
var attack_duration = 0.5
var attack_timer = 0.0
var is_dashing = false
var dash_timer = 0.0
var dash_cooldown_timer = 0.0
var dash_direction = Vector2.ZERO
var can_block: bool = true
var facing_direction = Vector2.RIGHT
var is_dead = false
var mouse_direction = Vector2.ZERO 

func _ready():
	LevelManager.player = self
	update_animation(Vector2(-1, 0))

# Process user input and state updates
func _process(delta: float) -> void:
	handle_input()
	
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			end_dash()
	if dash_cooldown_timer > 0:
		dash_cooldown_timer -= delta

func _physics_process(delta: float):
	if is_dashing:
		move_and_collide(velocity * delta)  # Move during dash
		return
	
	# Regular movement
	velocity = get_movement_input() * move_speed
	move_and_collide(velocity * delta)
	
	# Attack duration management
	if is_attacking:
		attack_timer += delta
		if attack_timer >= attack_duration:
			reset_attack()
			
	update_animation(velocity)

# Handle user input actions
func handle_input() -> void:
	var mouse_position = get_global_mouse_position()  # Update mouse direction
	mouse_direction = (mouse_position - global_position).normalized()

	if Input.is_action_pressed("block") and can_block:
		create_shield()
	if Input.is_action_just_pressed("inventory"):
		inventory_manager.interact_inventory()
	if Input.is_action_just_pressed("shoot"):
		shoot_projectile()
	if Input.is_action_just_pressed("attack") and not is_attacking:
		melee_attack() 
	if Input.is_action_just_pressed("dash") and not is_dashing and dash_cooldown_timer <= 0:
		start_dash()

# Get movement direction based on WASD
func get_movement_input() -> Vector2:
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	).normalized()
	if input_direction != Vector2.ZERO:
		facing_direction = input_direction
	return input_direction

# Update the player's movement animation
func update_animation(move_input: Vector2) -> void:
	animation_tree.set("parameters/Idle/blend_position", move_input)
	animation_tree.set("parameters/Walking/blend_position", move_input)

# Manage state transitions animation
func pick_new_state() -> void:
	if is_attacking:
		state_machine.travel("Attack")
		print("Attack")
	elif velocity != Vector2.ZERO:
		state_machine.travel("Walking")
	else:
		state_machine.travel("Idle")

# Trigger melee attack
func melee_attack() -> void:
	is_attacking = true
	attack_timer = 0.0  # Reset attack timer
	state_machine.travel("Attack")  # Transition to attack state
	play_attack_animation()  # Play the attack animation

# Play attack animation
func play_attack_animation() -> void:
	animation_tree.set("parameters/Attack/blend_position", mouse_direction) 
	animation_tree.set("parameters/Attack/speed", attack_animation_speed)

# Reset attack after its duration
func reset_attack() -> void:
	is_attacking = false
	attack_timer = 0.0
	pick_new_state()

# Create a shield when blocking
func create_shield() -> void:
	if can_block:
		can_block = false
		shield.enable_shield()
		health_component.is_invulnerable = true
		await get_tree().create_timer(2.0).timeout
		health_component.is_invulnerable = false
		can_block = true

# Shoot a projectile in the direction of the mouse
func shoot_projectile():
	var instance = projectile.instantiate()
	instance.direction = mouse_direction.normalized()
	instance.spawnPos = global_position 
	instance.fired_by = "player"
	
	var main = get_tree().current_scene
	if main:
		main.add_child.call_deferred(instance)
	else:
		print("Warning: Main scene is invalid!")

# Start dash
func start_dash() -> void:
	is_dashing = true
	health_component.is_invulnerable = true
	dash_direction = facing_direction
	dash_timer = dash_duration
	dash_cooldown_timer = dash_cooldown
	velocity = dash_direction * dash_speed

# End dash
func end_dash() -> void:
	is_dashing = false
	health_component.is_invulnerable = false
	velocity = Vector2.ZERO

# Handle player death
func _on_health_component_died() -> void:
	if is_dead: 
		return
	is_dead = true
	handle_death()

# Handle death-specific actions
func handle_death() -> void:
	var hurtbox = $HurtboxComponent
	if hurtbox and hurtbox.interaction_sound:
		hurtbox.interaction_sound.play()		# Play interaction sound if it exists
		await get_tree().create_timer(0.3).timeout	# Wait before continuing
		
	# Save camera before player dies
	var camera = get_node("MainCamera")
	if camera:
		camera.reparent(get_parent())
	
	queue_free()		# Remove the player

# Handle damage and visual feedback
func _on_hurtbox_component_damaged(_amount: float) -> void:
	sprite.modulate = Color(1, 0, 0)  
	await get_tree().create_timer(0.2).timeout
	sprite.modulate = Color(1, 1, 1)

# Reflect projectiles using the shield
func _on_shield_body_entered(body: Node2D) -> void:
	if body.has_method("bounce"):
		var normal = (body.global_position - global_position).normalized()  # Reflection normal
		body.bounce(normal)

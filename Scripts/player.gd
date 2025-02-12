extends CharacterBody2D

@export var move_speed: float = 100
@export var attack_speed: float = 1.0
@export var dash_speed: float = 300
@export var dash_duration: float = 0.3
@export var dash_cooldown: float = 1.0
@export var is_invulnerable = false
@export var projectile = load("res://Scenes/Templates/Projectile.tscn")

@onready var health_component = $HealthComponent
@onready var inventory_manager = %InventoryManager
@onready var shield = $Shield
@onready var melee_hurtbox = $MeleeHurtbox
@onready var sprite = $AnimatedSprite2D
@onready var main = get_tree().current_scene

var attack_direction = Vector2.ZERO
var is_attacking = false
var attack_duration = 1.0 / attack_speed
var attack_timer = 0.0
var is_dashing = false
var dash_timer = 0.0
var dash_cooldown_timer = 0.0
var dash_direction = Vector2.ZERO
var can_block: bool = true
var facing_direction = "right"
var is_dead = false
var mouse_direction = Vector2.ZERO 

func _ready():
	health_component.is_invulnerable = is_invulnerable
	LevelManager.player = self
	sprite.play("idle_right")
	
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
		move_and_collide(velocity * delta)
		return
	
	velocity = get_movement_input() * move_speed
	move_and_collide(velocity * delta)
	
	if is_attacking:
		attack_timer += delta
		if attack_timer >= attack_duration:
			reset_attack()
			
	update_animation()

func handle_input() -> void:
	var mouse_position = get_global_mouse_position()
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

func get_movement_input() -> Vector2:
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	).normalized()
	
	if input_direction != Vector2.ZERO:
		if input_direction.x > 0:
			facing_direction = "right"
		elif input_direction.x < 0:
			facing_direction = "left"
		elif input_direction.y > 0:
			facing_direction = "front"
		elif input_direction.y < 0:
			facing_direction = "back"
	
	return input_direction

func update_animation() -> void:
	sprite.flip_h = (facing_direction == "left")
	if is_attacking:
		sprite.play("attack_" + facing_direction)
	elif velocity != Vector2.ZERO:
		sprite.play("move_" + facing_direction)
	else:
		sprite.play("idle_" + facing_direction)

func melee_attack() -> void:
	is_attacking = true
	attack_timer = 0.0
	facing_direction = get_attack_direction()
	sprite.speed_scale = attack_speed  
	sprite.play("attack_" + facing_direction)

	# Get animation length
	var animation_name = "attack_" + facing_direction
	var anim_speed = sprite.get_sprite_frames().get_animation_speed(animation_name)
	var anim_length = sprite.get_sprite_frames().get_frame_count(animation_name) / anim_speed
	var hurtbox_duration = anim_length / attack_speed * 0.3  # Hurtbox active for 30% of the attack duration

	# Enable hurtbox briefly
	activate_melee_hurtbox(hurtbox_duration)

	# Wait for the animation to finish
	await get_tree().create_timer(anim_length / attack_speed, false, true).timeout
	
	reset_attack()

func activate_melee_hurtbox(duration: float) -> void:
	melee_hurtbox.monitoring = true  
	melee_hurtbox.visible = true  
	melee_hurtbox.position = get_hurtbox_position(facing_direction)

	# Disable after a short duration
	await get_tree().create_timer(duration, false, true).timeout
	melee_hurtbox.monitoring = false  
	melee_hurtbox.visible = false 
	
func get_hurtbox_position(direction: String) -> Vector2:
	match direction:
		"back": return Vector2(0, -10)
		"front": return Vector2(0, 10)
		"left": return Vector2(-10, 0)
		"right": return Vector2(10, 0)
	return Vector2.ZERO

func get_attack_direction() -> String:
	if abs(mouse_direction.x) > abs(mouse_direction.y):
		return "right" if mouse_direction.x > 0 else "left"
	return "front" if mouse_direction.y > 0 else "back"


func reset_attack() -> void:
	is_attacking = false
	sprite.speed_scale = 1.0
	update_animation()

func create_shield() -> void:
	if can_block:
		can_block = false
		shield.enable_shield()
		health_component.is_invulnerable = true
		await get_tree().create_timer(2.0).timeout
		health_component.is_invulnerable = false
		can_block = true

func shoot_projectile():
	var instance = projectile.instantiate()
	instance.direction = mouse_direction.normalized()
	instance.spawnPos = global_position 
	instance.fired_by = "player"
	
	main = get_tree().current_scene
	if main:
		main.add_child.call_deferred(instance)

func start_dash() -> void:
	is_dashing = true
	health_component.is_invulnerable = true
	dash_direction = velocity.normalized()
	dash_timer = dash_duration
	dash_cooldown_timer = dash_cooldown
	velocity = dash_direction * dash_speed

func end_dash() -> void:
	is_dashing = false
	health_component.is_invulnerable = false
	velocity = Vector2.ZERO
	
func handle_death() -> void:
	var hitbox = $HitboxComponent
	if hitbox and hitbox.interaction_sound:
		hitbox.interaction_sound.play()
		await get_tree().create_timer(0.3).timeout
	
	var camera = get_node("MainCamera")
	if camera:
		camera.reparent(get_parent())
	
	queue_free()

func _on_health_component_died() -> void:
	if is_dead:
		return
	is_dead = true
	handle_death()

func _on_shield_body_entered(body: Node2D) -> void:
	if body.has_method("bounce"):
		var normal = (body.global_position - global_position).normalized()
		body.bounce(normal)

func _on_hitbox_component_damaged(_amount: float) -> void:
	sprite.modulate = Color(1, 0, 0)  
	await get_tree().create_timer(0.2).timeout
	sprite.modulate = Color(1, 1, 1)

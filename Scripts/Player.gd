extends CharacterBody2D

#-----exportable variables-----#
@export var Move_speed : float = 200.0
@export var Attack_speed : float = 1.0
@export var Projectile = load("res://Scenes/Objects/Projectile.tscn")

#-----onready variables-----#
# Animation Variables
@onready var Player_sprite: AnimatedSprite2D = $AnimatedPlayer2D
# Action Variables
@onready var Tempo_shield: Area2D = $TempoShield
@onready var TS_durability: HealthComponent = $TempoShield/TSDurability
@onready var TS_hitbox: HitboxComponent = $TempoShield/TSHitbox

#-----Shield WIP-----#
#@onready var Shield: StaticBody2D = $Shield
#@onready var Shield_durability: HealthComponent = $Shield/ShieldDurability
#@onready var Shield_hitbox: HitboxComponent = $Shield/ShieldHitbox
#@onready var Shield_collision: CollisionShape2D = $Shield/ShieldCollision
#-----Shield WIP-----#

# Component Variables
@onready var Player_health: HealthComponent = $PlayerHealth
@onready var Player_hitbox: HitboxComponent = $PlayerHitbox
@onready var Melee_hurtbox: HurtboxComponent = $MeleeHurtbox

# Miscellenaous Variables
@onready var Main = get_tree().current_scene

#-----local variables-----#
# input/direction variables
var Input_direction : Vector2 = Vector2.ZERO
var Facing_direction : String = ""
var Mouse_direction : Vector2 = Vector2.ZERO

# Animation variables
const Idle : String = "Idle_"
const Move : String = "Move_"
const Attack : String = "Attack_"
const Death : String = "Death"

#---Action Variables---#
# Melee Variables
var Is_attacking : bool = false

# Blocking Variables
var Is_blocking : bool = false

# Shooting Variables

# Interaction Variables

func _ready() -> void:
	# initialize the player
	LevelManager.Player = self
	# Idle right is the default animation
	Player_sprite.play("Idle_right")
	# melee attack hurtbox is off by default
	Melee_hurtbox.monitoring = false
	Melee_hurtbox.visible = false
	# initialize the shield
	Tempo_shield.visible = false
	Tempo_shield.monitoring = false
	Tempo_shield.monitorable = false
	TS_hitbox.monitoring = false
	TS_hitbox.monitorable = false
	TS_hitbox.visible = false
	
	#-----Shield WIP-----#
	#Shield.visible = false
	#Shield_hitbox.monitoring = false
	#Shield_hitbox.visible = false
	#Shield_collision.disabled = true
	#-----Shield WIP-----#

func _physics_process(delta: float) -> void:
	# check if player is alive on every tick
	if !is_dead():
		# determines what the player inputs
		input_handling()
		
		# velocity and move_and_collide is essential for character movement
		# player cannot move while blocking
		if Is_blocking:
			velocity = Vector2.ZERO
		else:
			velocity = Input_direction * Move_speed
		
		# move_and_collide ensures that the player doesn't inherit the velicoty when colliding with walls
		# velocity is multiplied with the delta to ensure that movement is based on ticks
		move_and_collide(velocity * delta)
		
		# updates the input direction of the player every tick
		update_movement_input()
		
		# update the animation of the player
		update_animations()
	else: 
		player_dead()

#----------Input related functions----------#
func input_handling() -> void:
	# gets the position of the mouse and stores its vector values in mouse_direction
	# this is primarily used in determining the direction the player faces when doing an action such as an attack
	# this is also used for ranged/projectile calculation for the player
	var Mouse_position = get_global_mouse_position()
	Mouse_direction = (Mouse_position - global_position).normalized()
	
	# Player is now blocking
	if Input.is_action_pressed("block") and not Is_blocking:
		block()
	elif Input.is_action_just_released("block") and Is_blocking:
		end_block()
	# if melee button is pressed and previously not doing a melee attack
	# player should not be able to attack while blocking
	# note that the player can only equip either a melee or a projectile weapon so this will be adjusted eventually
	# Player should not be able to do anything while blocking
	if !Is_blocking:
		if Input.is_action_just_pressed("attack") and not Is_attacking:
			melee_attack()
		if Input.is_action_just_pressed("shoot"):
				shoot_projectile()

# determines where the player attacks based on the mouse position
func get_mouse_direction() -> String:
	if abs(Mouse_direction.x) > abs(Mouse_direction.y):
		return "right" if Mouse_direction.x > 0 else "left"
	return "down" if Mouse_direction.y > 0 else "up"

# adjust the position of either the attack or the shield
func get_object_spawn_position(Direction: String) -> Vector2:
	match Direction:
		"up": return Vector2(0, -10)
		"down": return Vector2(0, 10)
		"left": return Vector2(-10, 0)
		"right": return Vector2(10, 0)
	return Vector2.ZERO

#----------movement related functions----------#
func update_movement_input():
	# global var input direction is updated in this function
	Input_direction = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	).normalized() # .normalized() returns resultant vector if multiple inputs are pressed
	# .normalized is important to eliminate velocity discrepancies
	
	# used to determine the position the player is facing
	# used for idle animations in the idle_animations
	if Input_direction != Vector2.ZERO:
		if Input_direction.x > 0:
			Facing_direction = "right"
		elif Input_direction.x < 0:
			Facing_direction = "left"
		elif Input_direction.y > 0:
			Facing_direction = "down"
		elif Input_direction.y < 0:
			Facing_direction = "up"

#----------animation related functions----------#
# handles the animations of the player
func update_animations() -> void:
	# if player is facing left, flip the sprite
	Player_sprite.flip_h = (Facing_direction == "left")
	
	# if player is blocking, other animations shouldn't play
	if !Is_blocking:
		if Is_attacking:
			Player_sprite.play(Attack + Facing_direction)
		elif velocity != Vector2.ZERO:
			Player_sprite.play(Move + Facing_direction)
		# play the Idle Animation Again for the condition that the player is not moving while not blocking
		else:
			Player_sprite.play(Idle + Facing_direction)
	# play idle animation if player is not moving
	else:
		Player_sprite.play(Idle + Facing_direction)
		# note: autoplay is set to idle_left

#----------melee related functions----------#
func melee_attack() -> void: 
	print("haha i attack u")
	Is_attacking = true
	# make the player face the mouse when attacking
	Facing_direction = get_mouse_direction()
	# adjust the animation speed based on attack speed
	Player_sprite.speed_scale = Attack_speed
	#-------Attack Animation Handling-------#
	# update the animations to play the attack animation
	update_animations()
	
	# animation length determines how long the attack animation plays for
	var Attack_animation_name : String = Attack + Facing_direction
	var Attack_animation_speed : float = Player_sprite.get_sprite_frames().get_animation_speed(Attack_animation_name) # the speed in which the whole animation plays out
	var Attack_animation_frames : float = Player_sprite.get_sprite_frames().get_frame_count(Attack_animation_name) # the nmumber of frames in the animation
	var Attack_animation_length : float = (Attack_animation_frames / Attack_animation_speed) / Attack_speed # the length of the whole animation
	var Attack_frame_speed : float = Attack_animation_length / Attack_animation_frames # the duration of each frame
	
	var Hurtbox_delay = Attack_frame_speed
	var Hurtbox_duration = Attack_frame_speed * 1 # based on the animations, the attack part of the sprite plays for 1 frames
	
	# call activate the melee hurtbox
	activate_melee_hurtbox(Hurtbox_delay, Hurtbox_duration)
	
	# wait for the attack animation to finish
	# Attack_animation_length - Attack_frame_speed is done in order to prevent extra frames from playing
	await get_tree().create_timer(Attack_animation_length - Attack_frame_speed, false, true).timeout
	#activate_melee_hurtbox(Hurtbox_duration)
	
	# end attack animation after
	end_attack_animation()
	#-------Attack Animation Handling-------#

func end_attack_animation() -> void: 
	Is_attacking = false
	Player_sprite.speed_scale = 1.0  # Reset the animation speed to normal

func activate_melee_hurtbox(Delay : float, Duration : float) -> void: 
	# wait for the attack animation to swing the sword
	await get_tree().create_timer(Delay, false, true).timeout
	# activate the meleehurtbox
	# monitoring allows the hurtbox to exist functionally
	# visible allows to see the hurtbox appear
	Melee_hurtbox.monitoring = true
	Melee_hurtbox.visible = true
	Melee_hurtbox.position = get_object_spawn_position(Facing_direction)
	
	# Disable after a short duration
	await get_tree().create_timer(Duration, false, true).timeout
	Melee_hurtbox.monitoring = false  
	Melee_hurtbox.visible = false 

#----------shooting related functions----------#
func shoot_projectile():
	print("Im shooting mf")
	var ProjectileInstance = Projectile.instantiate()
	ProjectileInstance.Direction = Mouse_direction.normalized()
	ProjectileInstance.SpawnPos = global_position
	ProjectileInstance.Fired_by = "Player"
	
	# Main = get_tree calls the current scene
	Main = get_tree().current_scene
	if Main:
		# this adds the projectile as a child of the scene itself, to ensure that if the object that called it dies, the projectile doesn't disappear too early
		Main.add_child.call_deferred(ProjectileInstance)

#----------blocking related functions----------#
func block() -> void:
	
	# adjust collision timing to be if parrying
	
	Is_blocking = true
	print("I'm blocking")
	# turn off player health damage
	Player_health.Is_object_blocking = true
	Player_hitbox.monitoring = false
	
	# get Shield Direction
	Facing_direction = get_mouse_direction()
	
	Tempo_shield.position = get_object_spawn_position(Facing_direction)
	Tempo_shield.visible = true
	Tempo_shield.monitoring = true
	Tempo_shield.monitorable = true
	TS_hitbox.monitoring = true
	TS_hitbox.monitorable = true
	TS_hitbox.visible = true
	
	#-----Shield WIP-----#
	## rotate shield appropriately
	#if Facing_direction == "up":
		#Shield.rotation = deg_to_rad(90)
	#elif Facing_direction == "down":
		#Shield.rotation = deg_to_rad(270)
	#else:
		#Shield.rotation = deg_to_rad(0)
	#
	## activate the shield
	#Shield.position = get_object_spawn_position(Facing_direction)
	#Shield.visible = true
	#Shield_collision.disabled = false
	## activate the shield hitbox
	#Shield_hitbox.monitoring = true
	#Shield_hitbox.visible = true
	#-----Shield WIP-----#
	
func end_block() -> void:
	Is_blocking = false
	print("I'm done blocking")
	# turn on health damage
	Player_health.Is_object_blocking = false
	Player_hitbox.monitoring = true
	
	Tempo_shield.visible = false
	Tempo_shield.monitoring = false
	Tempo_shield.monitorable = false
	TS_hitbox.monitoring = false
	TS_hitbox.monitorable = false
	TS_hitbox.visible = false
	
	# disable the shield again
	#-----Shield WIP-----#
	#Shield.visible = false
	#Shield_collision.disabled = true
	#Shield_hitbox.monitoring = false
	#Shield_hitbox.visible = false
	#-----Shield WIP-----#

#----------component related functions----------#
func is_dead() -> bool:
	return Player_health.Health <= 0
	
func player_dead() -> void:
	Player_sprite.play(Death)
	# ensure that the player doesn't take damage anymore
	Player_hitbox.monitoring = false
	
	#-------Death Animation Handling-------#
	# same method as seen in the attack animation handling
	var Death_animation_name : String = Death
	var Death_animation_speed : float = Player_sprite.get_sprite_frames().get_animation_speed(Death_animation_name) # the speed in which the whole animation plays out
	var Death_animation_frames : float = Player_sprite.get_sprite_frames().get_frame_count(Death_animation_name) # the nmumber of frames in the animation
	var Death_animation_length : float = (Death_animation_frames / Death_animation_speed) # the length of the whole animation
	var Death_frame_speed : float = Death_animation_length / Death_animation_frames # the duration of each frame
	
	# wait for the death animation to finish playing
	await get_tree().create_timer(Death_animation_length - Death_frame_speed, false, true).timeout
	#-------Death Animation Handling-------#
	
	queue_free()

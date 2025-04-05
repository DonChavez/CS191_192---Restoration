extends CharacterBody2D

#-----exportable variables-----#

@export var Projectile = load("res://Scenes/Objects/Projectile.tscn")
# Blocking Variables
@export var Is_parrying : bool = false
# Audio Variables
@export var Audio_player: AudioStreamPlayer2D
@export var sfx_folder: String = "res://Music/SFX/Grass/"
var sfx_files: Array = []

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
@onready var Melee_collision: CollisionShape2D = $MeleeHurtbox/CollisionShape2D
@onready var Main = null
@onready var Inventory: InventoryObject = $"UI Wrapper/Inventory"
@onready var Effect_manager: Node = $EffectManager

#-----local variables-----#
# input/direction variables
var Input_direction : Vector2 = Vector2.ZERO
var Facing_direction : String = "right"
var Mouse_direction : Vector2 = Vector2.ZERO

# Status Variables
var Upgrade_status_count: Dictionary = {
	"Health": 0,
	"Melee": 0,
	"Range": 0,
	"Attack Speed": 0,
	"Speed": 0
	}
# Base Stats holder
@onready var Base_Move_speed : float = 170.0
@onready var Base_Attack_speed : float = 1.0
@onready var Base_Max_health: float = 100.0
@onready var Base_Projectile_dmg: float = 10.0
@onready var Base_Melee_dmg: float = 20.0
# Increment Stats for player
@onready var Incr_Move_speed : float = 0
@onready var Incr_Attack_speed : float = 0
@onready var Incr_Max_health: float = 0
@onready var Incr_Projectile_dmg: float = 0
@onready var Incr_Melee_dmg: float = 0
# Use Stats for player
@onready var Used_Move_speed : float = Base_Move_speed
@onready var Used_Attack_speed : float = Base_Attack_speed
@onready var Used_Max_health: float = Base_Max_health
@onready var Used_Projectile_dmg: float = Base_Projectile_dmg
@onready var Used_Melee_dmg: float = Base_Melee_dmg
# Variables for specific items
@onready var Successful_hits: int = 0
@onready var Percent_melee_damage_bonus: float = 0
@onready var Percent_max_health_bonus: float = 0
# death flag
var Player_is_dead = false

# Animation variables
const Idle : String = "Idle_"
const Move : String = "Move_"
const Attack : String = "Attack_"
const Death : String = "Death"

#---Action Variables---#
# Melee Variables
var Is_attacking : bool = false
var Has_melee: int = 0
var Spinning: bool = false
var Melee_x_additional: int = 0
var Melee_y_additional: int = 0
var Sword_list: Array
var Life_steal:float = 0

# Blocking Variables
var Is_blocking : bool = false
var Parry_window : float = 0.5

# Shooting Variables
var Projectile_bounce_count : int = 0
var Spread_shot_count: int = 0
var Multi_shot_count: int = 1
var Reloading: bool = false
var Has_range: int = 0

# Projectile Variables
var Live_time_addition:int = 0
var Pierce_addition:int = 1

# Interaction Variables
var Can_process_input : bool = true
var Can_process_movement : bool = true

func _ready() -> void:
	await get_tree().process_frame
	# Idle right is the default animation
	Player_sprite.play("Idle_right")
	# melee attack hurtbox is off by default
	Melee_hurtbox.monitoring = false
	Melee_hurtbox.visible = false
	
	# initialize the shield
	Tempo_shield.visible = false
	Tempo_shield.monitoring = false
	Tempo_shield.monitorable = false	#Fix
	TS_hitbox.monitoring = false
	TS_hitbox.monitorable = false	#Fix
	TS_hitbox.visible = false
	
	#-----Shield WIP-----#
	#Shield.visible = false
	#Shield_hitbox.monitoring = false
	#Shield_hitbox.visible = false
	#Shield_collision.disabled = true
	#-----Shield WIP-----#

func _physics_process(delta: float) -> void:
	# check if player is alive on every tick
	if !Player_is_dead:
		# determines what the player inputs
		input_handling()
		# velocity and move_and_collide is essential for character movement
		# player cannot move while blocking
		if Is_blocking:
			velocity = Vector2.ZERO
		else:
			velocity = Input_direction * Used_Move_speed
		
		# move_and_collide ensures that the player doesn't inherit the velicoty when colliding with walls
		# velocity is multiplied with the delta to ensure that movement is based on ticks
		move_and_slide()
		
		# updates the input direction of the player every tick
		update_movement_input()
		
		# update the animation of the player
		update_animations()

#----------Input related functions----------#
func input_handling() -> void:
	if not Can_process_input:
		return
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
		if Input.is_action_just_pressed("attack") and not Is_attacking and Has_melee:
			melee_attack()
		if Input.is_action_just_pressed("shoot") and not Reloading and Has_range:
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
	if !Can_process_movement:
		return
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
				# adjust animation speed based on movement speed
			if velocity.length() > 0:
				var base_speed = 75.0  # Set this to the move speed where animation looks normal
				Player_sprite.speed_scale = Used_Move_speed / base_speed
			else:
				Player_sprite.speed_scale = 1.0  # Reset when idle
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
	Player_sprite.speed_scale = Used_Attack_speed
	find_used_melee_damage()
	
	#-------Attack Animation Handling-------#
	# update the animations to play the attack animation
	update_animations()
	
	# animation length determines how long the attack animation plays for
	var Attack_animation_name : String = Attack + Facing_direction
	var Attack_animation_speed : float = Player_sprite.get_sprite_frames().get_animation_speed(Attack_animation_name) # the speed in which the whole animation plays out
	var Attack_animation_frames : float = Player_sprite.get_sprite_frames().get_frame_count(Attack_animation_name) # the nmumber of frames in the animation
	var Attack_animation_length : float = (Attack_animation_frames / Attack_animation_speed) / Used_Attack_speed # the length of the whole animation
	var Attack_frame_speed : float = Attack_animation_length / Attack_animation_frames # the duration of each frame
	
	var Hurtbox_delay = Attack_frame_speed
	var Hurtbox_duration = Attack_frame_speed * 1 # based on the animations, the attack part of the sprite plays for 1 frames
	
	# call activate the melee hurtbox
	activate_melee_hurtbox(Hurtbox_delay, Hurtbox_duration)
	
	# wait for the attack animation to finish
	# Attack_animation_length - Attack_frame_speed is done in order to prevent extra frames from playing
	Melee_hurtbox.apply_interval(Attack_animation_length - Attack_frame_speed)
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
	var Holder = Successful_hits
	Melee_hurtbox.success_check()
	Melee_hurtbox.visible = true
	Melee_hurtbox.position = get_object_spawn_position(Facing_direction)
	
	if "Spin Sword" in Sword_list:
		Melee_hurtbox.position = Vector2(0,0)
	var Attack_direction = use_melee_weapon("")		# any shape changes are temporary
	
	# Disable after a short duration
	await get_tree().create_timer(Duration, false, true).timeout
	Melee_hurtbox.monitoring = false
	if "Sword Hate" not in Sword_list or Successful_hits == Holder:# For checking consecutive hits
		Successful_hits = 0
	Melee_hurtbox.visible = false
	print("Successful hits: ",Successful_hits)
	print("Damage: ",Used_Melee_dmg) 
	use_melee_weapon(Attack_direction)				# Removed here with the same direction

func apply_melee_weapon(Melee_x: int, Melee_y: int, Weapon: String, Equip: bool) -> void:
	if not Equip:
		Sword_list.erase(Weapon)
	else:
		Sword_list.append(Weapon)
	Melee_x_additional += Melee_x
	Melee_y_additional += Melee_y
	
	
func use_melee_weapon(Direction: String) -> String:
	print(Melee_x_additional,", ",Melee_y_additional)
	var Usage = -1
	if not Direction:	# Determines if adding or removing
		Direction = Facing_direction
		Usage = 1
	var shape = Melee_collision.shape	
	match Direction:	
		"left":
			shape.extents.x += (Melee_x_additional) * Usage
			shape.extents.y += (Melee_y_additional) * Usage
		"right":
			shape.extents.x += (Melee_x_additional) * Usage
			shape.extents.y += (Melee_y_additional) * Usage
		"up":
			shape.extents.x += (Melee_y_additional) * Usage
			shape.extents.y += (Melee_x_additional) * Usage
		"down":
			shape.extents.x += (Melee_y_additional) * Usage
			shape.extents.y += (Melee_x_additional) * Usage
	return Direction
#----------shooting related functions----------#
# Shoots projectile with spread functionality
func shoot_projectile():
	Reloading = true
	print("Shooting with spread shot")

	var Total_projectiles = 1 + Spread_shot_count
	var Spread_angle = deg_to_rad(30)  # spread angle in radians

	# calculate angle step for spreading projectiles evenly
	var Spread_step = Spread_angle / max(1, Total_projectiles - 1)
	var Center_index = Total_projectiles / 2

	for k in range(Multi_shot_count):
		for i in range(Total_projectiles):
			var Projectile_instance = Projectile.instantiate()
			# ensure that one of the projectiles is going center
			var Angle_offset = (i - Center_index) * Spread_step
			if Total_projectiles % 2 == 0 and i == Center_index:
				Angle_offset = 0.0 
			
			Projectile_instance.Direction = Mouse_direction.rotated(Angle_offset).normalized()
			Projectile_instance.SpawnPos = global_position
			Projectile_instance.Fired_by = self
			Projectile_instance.MaxBounces = Projectile_bounce_count
			Projectile_instance.Lifetime += Live_time_addition
			Projectile_instance.MaxPierce += Pierce_addition
			
			# add projectile to the current scene
			Main = get_tree().current_scene
			if Main:
				Main.add_child(Projectile_instance)
				
			Projectile_instance.implement_damage(Used_Projectile_dmg)
		await get_tree().create_timer(0.09).timeout
	reloaded()

func reloaded() -> void:
	await get_tree().create_timer(1/Used_Attack_speed).timeout
	Reloading = false

#----------blocking related functions----------#
func block() -> void:
	# adjust collision timing to be if parrying
	Is_blocking = true
	print("I'm blocking")
	# turn off player health damage
	Player_hitbox.monitoring = false
	Player_hitbox.monitorable = false

	
	# get Shield Direction
	Facing_direction = get_mouse_direction()
	
	# Enable Temporary Shield
	Tempo_shield.position = get_object_spawn_position(Facing_direction)
	Tempo_shield.visible = true
	Tempo_shield.monitoring = true
	Tempo_shield.monitorable = true
	Tempo_shield.monitoring = true
	Tempo_shield.monitorable = true
	TS_hitbox.monitoring = true
	TS_hitbox.monitorable = true
	TS_hitbox.monitorable = true
	TS_hitbox.visible = true
	
	# parrying
	Is_parrying = true
	print("I'm parrying")
	
	# wait for the parry window to end
	await get_tree().create_timer(Parry_window).timeout
	
	Is_parrying = false
	
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
	Player_hitbox.monitoring = true
	Player_hitbox.monitorable = true
	
	Tempo_shield.visible = false
	Tempo_shield.monitorable = false
	Tempo_shield.monitoring = false
	TS_hitbox.monitoring = false
	TS_hitbox.monitorable = false
	TS_hitbox.visible = false
	TS_hitbox.monitorable = false
	
	# disable the shield again
	#-----Shield WIP-----#
	#Shield.visible = false
	#Shield_collision.disabled = true
	#Shield_hitbox.monitoring = false
	#Shield_hitbox.visible = false
	#-----Shield WIP-----#

#----------component related functions----------#
func _on_player_health_died() -> void:
	if Player_is_dead:
		return  # exit if already dead
	Player_is_dead = true  # set death flag to prevent multiple calls

	Player_sprite.play("Death")
	# Ensure that the player doesn't take damage anymore
	Player_hitbox.monitoring = false

	# onnect the animation_finished signal to a handler function
	await Player_sprite.animation_finished
	
	# delay before queue free
	await get_tree().create_timer(0.5).timeout
	
func _on_player_health_damage_taken(_Amount: float) -> void:
	var original_color = modulate  # Store the original color
	Player_sprite.modulate = Color(1, 0, 0)  # Flash red
	
	# Return to the original color after a short delay
	await get_tree().create_timer(0.2).timeout
	Player_sprite.modulate = original_color
	
#----------item related functions----------#
func get_inventory() -> InventoryObject:
	return Inventory
# Value used to check we have a weapon
func get_range(Value: int) -> void:
	Has_range = Value
func get_melee(Value: int) -> void:
	Has_melee = Value

func add_successful_hits() -> void:
	Successful_hits += 1

func do_life_steal(Damage_dealt:float) -> void:
	print("Lifesteal: ", Life_steal)
	Player_health.heal(Damage_dealt*Life_steal)
	 
	
#----------status upgrade related functions----------#
func get_effect_manager() -> Node:
	return Effect_manager

func get_curr_upgrade(Stat_name: String) -> int:
	return Upgrade_status_count[Stat_name]
	
func add_curr_upgrade(Stat_name: String) -> void:
	Upgrade_status_count[Stat_name] += 1
	
func get_upgrade_counter() -> Dictionary:
	return Upgrade_status_count

func reset_attributes() -> void:
	Used_Max_health = Base_Max_health
	Player_health.apply_new_health(Base_Max_health)
	Used_Melee_dmg = Base_Melee_dmg
	Melee_hurtbox.hurtbox_implement_damage(Base_Melee_dmg)
	Used_Projectile_dmg = Base_Projectile_dmg
	Used_Attack_speed = Base_Attack_speed
	Used_Move_speed = Base_Move_speed
	# ---
	Has_melee = 0
	Spinning = false
	Melee_x_additional = 0
	Melee_y_additional = 0
	Sword_list = []
	Projectile_bounce_count= 0
	Spread_shot_count= 0
	Multi_shot_count = 1
	Has_range= 0
	Live_time_addition= 0
	Pierce_addition = 1


#----------get base status functions----------#

func get_max_health() -> float:
	return Base_Max_health

func get_melee_damage() -> float:
	return Base_Melee_dmg

func get_projectile_damage() -> float:
	return Base_Projectile_dmg

func get_attack_speed() -> float:
	return Base_Attack_speed

func get_movement_speed() -> float:
	return Base_Move_speed

#----------Edit base status functions----------#
# This is for Trainer
func add_max_health(Amount: float) -> void:
	Base_Max_health += Amount
	find_used_max_health()

func add_melee_damage(Amount: float) -> void:
	Base_Melee_dmg += Amount
	find_used_melee_damage()

func add_projectile_damage(Amount: float) -> void:
	Base_Projectile_dmg += Amount
	find_used_projectile_damage()
func add_attack_speed(Amount: float) -> void:
	Base_Attack_speed += Amount
	find_used_attack_speed()
func add_movement_speed(Amount: float) -> void:
	Base_Move_speed += Amount
	find_used_movement_speed()
# This is for flat amount increase
func add_incr_max_health(Amount: float) -> void:
	Incr_Max_health += Amount
	find_used_max_health()

func add_incr_melee_damage(Amount: float) -> void:
	Incr_Melee_dmg += Amount
	find_used_melee_damage()

func add_incr_projectile_damage(Amount: float) -> void:
	Incr_Projectile_dmg += Amount
	find_used_projectile_damage()
func add_incr_attack_speed(Amount: float) -> void:
	Incr_Attack_speed += Amount
	find_used_attack_speed()
func add_incr_movement_speed(Amount: float) -> void:
	Incr_Move_speed += Amount
	find_used_movement_speed()

# This is for percent amount increase
func add_percent_max_health(Amount: int) -> void:
	Percent_max_health_bonus += (Amount*0.01)
	find_used_max_health()
	
func add_percent_melee_damage(Amount: int) -> void:
	Percent_melee_damage_bonus += (Amount*0.01)
	find_used_melee_damage()
	
#----------find used status functions----------#
func find_used_max_health() -> void:
	Used_Max_health = (Base_Max_health + Incr_Max_health) * (1 + Percent_max_health_bonus)
	Player_health.apply_new_health(Used_Max_health)

func find_used_melee_damage() -> void:
	var Used_percent = Percent_melee_damage_bonus * Successful_hits
	Used_Melee_dmg = (Base_Melee_dmg + Incr_Melee_dmg) * (1 + Used_percent)
	print("Calculated damage: ", Used_Melee_dmg)
	Melee_hurtbox.hurtbox_implement_damage(Used_Melee_dmg)

func find_used_projectile_damage() -> void:
	Used_Projectile_dmg = Base_Projectile_dmg + Incr_Projectile_dmg

func find_used_attack_speed() -> void:
	Used_Attack_speed = Base_Attack_speed + Incr_Attack_speed

func find_used_movement_speed() -> void:
	Used_Move_speed = Base_Move_speed + Incr_Move_speed

# Melee and Range Weapon Flat Amount
func add_used_projectile_bounce_count(Amount: int) -> void:
	Projectile_bounce_count += Amount

func add_used_spread_shot_count(Amount: int) -> void:
	Spread_shot_count += Amount

func add_used_multi_shot_count(Amount: int) -> void:
	Multi_shot_count += Amount

func add_used_live_time_addition(Amount: int) -> void:
	Live_time_addition += Amount	#Projectile life time

func add_used_pierce_addition(Amount: int) -> void:
	Pierce_addition += Amount

func add_used_lifesteal_percent(Amount: int) -> void:
	Life_steal += (Amount*0.01)

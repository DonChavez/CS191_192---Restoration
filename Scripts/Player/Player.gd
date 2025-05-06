extends CharacterBody2D

#-----exportable variables-----#
@export var Projectile = load("res://Scenes/Objects/Projectile.tscn")
# Blocking Variables
@export var Is_parrying : bool = false
# Audio Variables
@export var Attack_sound = preload("res://Music/SFX/Player/melee_attack.mp3")
@export var Ranged_sound = preload("res://Music/SFX/Player/ranged_attack.mp3")



# Damage Variables
@export var Knockback_strength : float = 250.0
var knockback_velocity: Vector2 = Vector2.ZERO
var knockback_timer := 0.0
const KNOCKBACK_DURATION := 0.5
const KNOCKBACK_STRENGTH := 1000.0
@export var knockback_decay_rate: float = 6.0

#-----onready variables-----#
# Animation Variables
@onready var Player_sprite: AnimatedSprite2D = $AnimatedPlayer2D
@onready var Player_camera: Camera2D = $Camera2D

# Action Variables
@onready var Tempo_shield: Area2D = $TempoShield
@onready var TS_durability: HealthComponent = $TempoShield/TSDurability
@onready var TS_hitbox: HitboxComponent = $TempoShield/TSHitbox

# Component Variables
@onready var Player_health: HealthComponent = $PlayerHealth
@onready var Player_hitbox: HitboxComponent = $PlayerHitbox
@onready var Melee_hurtbox: HurtboxComponent = $MeleeHurtbox

# Miscellaneous Variables
@onready var Melee_collision: CollisionShape2D = $MeleeHurtbox/CollisionShape2D
@onready var Main = null
@onready var Inventory: InventoryObject = $"UI Wrapper/Inventory"
@onready var HUD = $"UI Wrapper/HUD"
@onready var Effect_manager: Node = $EffectManager
@onready var Player_sfx: AudioStreamPlayer2D = $PlayerSFX
@onready var Player_walking_sfx: AudioStreamPlayer2D = $PlayerWalkingSFX

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
@onready var Base_move_speed : float = 170.0
@onready var Base_attack_speed : float = 1.0
@onready var Base_max_health: float = 100.0
@onready var Base_projectile_dmg: float = 10.0
@onready var Base_melee_dmg: float = 200.0
# Increment Stats for player
@onready var Incr_move_speed : float = 0
@onready var Incr_attack_speed : float = 0
@onready var Incr_max_health: float = 0
@onready var Incr_projectile_dmg: float = 0
@onready var Incr_melee_dmg: float = 0
# Use Stats for player
@onready var Used_move_speed : float = Base_move_speed
@onready var Used_attack_speed : float = Base_attack_speed
@onready var Used_max_health: float = Base_max_health
@onready var Used_projectile_dmg: float = Base_projectile_dmg
@onready var Used_melee_dmg: float = Base_melee_dmg
# Variables for specific items
@onready var Successful_hits: int = 0
@onready var Percent_hate_damage_bonus: float = 0
@onready var Dash_distance: float = 100
@onready var Dash_cooldown: float = 1
@onready var Can_dash : bool = false

@onready var Percent_max_health_bonus: float = 0
@onready var Percent_melee_damage_bonus: float = 0
@onready var Percent_movement_speed_bonus: float = 0
@onready var Percent_Projectile_damage: float = 0

@onready var Last_direction: Vector2 = Vector2.ZERO
@onready var Percent_damage_reduction: float = 0
@onready var Percent_life_steal: float = 0

# death flag
var Player_is_dead = false

# Animation variables
const Idle : String = "Idle_"
const Move : String = "Move_"
const Attack : String = "Attack_"
const Death : String = "Death"
const Shield : String = "Shield_"

#---Action Variables---#
var Can_attack: bool = true
# Melee Variables
var Is_attacking : bool = false
var Has_melee: int = 0
var Spinning: bool = false
var Melee_x_additional: int = 0
var Melee_y_additional: int = 0
var Sword_list: Array

# damaged variables
var Is_hit : bool = false
var Knockback_direction : Vector2 = Vector2.ZERO
var Light_sword:HitboxComponent

# Blocking Variables
var Is_blocking : bool = false
var Parry_window : float = 0.5
var Can_block: bool = true
var Disappear_time: float = 0
var Parry_bonus: float = 0
var Parry_bonus_time: float = 0

# Shooting Variables
var Projectile_bounce_count : int = 0
var Spread_shot_count: int = 0
var Multi_shot_count: int = 0
var Reloading: bool = false
var Has_range: int = 0

# Projectile Variables
var Live_time_addition: int = 0
var Pierce_addition: int = 0

# Interaction Variables
var Can_process_input : bool = true
var Can_process_movement : bool = true

func _ready() -> void:
	await get_tree().process_frame
	Player_sprite.play("Idle_right")
	Melee_hurtbox.monitoring = false
	Melee_hurtbox.visible = false
	
	Tempo_shield.visible = false
	Tempo_shield.monitoring = false
	Tempo_shield.monitorable = false
	TS_hitbox.monitoring = false
	TS_hitbox.monitorable = false
	TS_hitbox.visible = false
	
	# Connect signal for projectile modification
	Tempo_shield.connect("area_entered", _on_tempo_shield_area_entered)

func _physics_process(delta: float) -> void:
	if Player_is_dead:
		return

	input_handling()

	var base_velocity = Vector2.ZERO
	if Is_blocking or Is_attacking:
		base_velocity = Vector2.ZERO
	else:
		base_velocity = Input_direction * Used_move_speed

	if knockback_velocity.length() > 1.0:
		position += knockback_velocity * delta
		# Exponential decay
		knockback_velocity *= exp(-knockback_decay_rate * delta)
	else:
		knockback_velocity = Vector2.ZERO

	# Combine the base velocity with knockback velocity
	velocity = base_velocity + knockback_velocity
	
	# Pass the resultant velocity to move_and_slide
	move_and_collide(velocity*delta)

	update_movement_input()
	update_animations()

#----------Input related functions----------#
func input_handling() -> void:
	if not Can_process_input:
		return
	var Mouse_position = get_global_mouse_position()
	Mouse_direction = (Mouse_position - global_position).normalized()
	
	if Input.is_action_just_pressed("dash") and Can_dash:
		dash()
	
	# Player is now blocking
	if Input.is_action_pressed("block") and not Is_blocking and Can_block:
		block()
	elif Input.is_action_just_released("block") and Is_blocking:
		end_block()
	
	# if melee button is pressed and previously not doing a melee attack
	# player should not be able to attack while blocking
	# note that the player can only equip either a melee or a projectile weapon so this will be adjusted eventually
	# Player should not be able to do anything while blocking
	if !Is_blocking and Can_attack:
		if Input.is_action_just_pressed("attack") and not Is_attacking and Has_melee:
			melee_attack()
		if Input.is_action_just_pressed("shoot") and not Reloading and Has_range:
			shoot_projectile()

func get_mouse_direction() -> String:
	if abs(Mouse_direction.x) > abs(Mouse_direction.y):
		return "right" if Mouse_direction.x > 0 else "left"
	return "down" if Mouse_direction.y > 0 else "up"

func get_object_spawn_position(Direction: String) -> Vector2:
	match Direction:
		"up": return Vector2(0, -10)
		"down": return Vector2(0, 10)
		"left": return Vector2(-10, 0)
		"right": return Vector2(10, 0)
	return Vector2.ZERO

#----------movement related functions----------#
func update_movement_input():
	if !Can_process_movement or Is_blocking:  # Prevent direction updates while blocking
		Input_direction = Vector2.ZERO
		return
	Input_direction = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	).normalized()
	
	if Input_direction != Vector2.ZERO:
		if Input_direction.x > 0:
			Facing_direction = "right"
		elif Input_direction.x < 0:
			Facing_direction = "left"
		elif Input_direction.y > 0:
			Facing_direction = "down"
		elif Input_direction.y < 0:
			Facing_direction = "up"
		Last_direction = Input_direction

func dash() -> void:
	if !Can_process_movement:
		return
		
	if Player_sfx:
		Player_sfx.stream = preload("res://Music/SFX/Player/dash.mp3")
		Player_sfx.play()
	if Last_direction == Vector2.ZERO:
		Last_direction = Vector2.RIGHT
	
	# Save position before dash
	var Pre_dash_position = global_position
	
	var Dash_vector = Last_direction.normalized() * Dash_distance
	var Target_position = global_position + Dash_vector
	
	var Space_state = get_world_2d().direct_space_state
	var Query = PhysicsRayQueryParameters2D.create(global_position, Target_position)
	Query.collide_with_areas = false
	Query.collide_with_bodies = true
	Query.collision_mask = 1 << 0
	var Result = Space_state.intersect_ray(Query)
	
	if Result:
		var Safe_position = Result.position - (Last_direction.normalized() * 2)
		global_position = Safe_position
	else:
		global_position = Target_position
	
	Player_camera.on_player_dashed(Pre_dash_position)	# For animation
	
	Can_dash = false
	await get_tree().create_timer(Dash_cooldown).timeout
	Can_dash = true


#----------animation related functions----------#
func update_animations() -> void:
	Player_sprite.flip_h = (Facing_direction == "left")
	
	if Is_blocking:
		match Facing_direction:
			"up":
				Player_sprite.play(Shield + "up")
			"down":
				Player_sprite.play(Shield + "down")
			"left", "right":
				Player_sprite.play(Shield + "side")
				Player_sprite.flip_h = (Facing_direction == "left")
	else:
		if Is_attacking:
			Player_sprite.play(Attack + Facing_direction)
		elif velocity != Vector2.ZERO:
			if velocity.length() > 0:
				var base_speed = 75.0
				Player_sprite.speed_scale = Used_move_speed / base_speed
			else:
				Player_sprite.speed_scale = 1.0
			Player_sprite.play(Move + Facing_direction)
			if Player_walking_sfx  and not Player_walking_sfx.playing:
				Player_walking_sfx.play()
		else:
			Player_sprite.play(Idle + Facing_direction)
			if Player_walking_sfx and Player_walking_sfx.playing:
				Player_walking_sfx.stop()

#----------blocking related functions----------#
func block() -> void:
	Is_blocking = true
	print("I'm blocking")
	
	Player_hitbox.monitoring = false
	Player_hitbox.monitorable = false
	
	Facing_direction = get_mouse_direction()  # Set direction once at block start
	
	# Position TS_hitbox based on direction
	Tempo_shield.position = get_object_spawn_position(Facing_direction)
	Tempo_shield.monitoring = true
	Tempo_shield.monitorable = true
	TS_hitbox.monitoring = true
	TS_hitbox.monitorable = true
	TS_hitbox.visible = true  
	
	Is_parrying = true
	print("I'm parrying")
	
	await get_tree().create_timer(Parry_window).timeout
	Is_parrying = false

func end_block() -> void:
	Is_blocking = false
	print("I'm done blocking")
	
	Player_hitbox.monitoring = true
	Player_hitbox.monitorable = true
	
	Tempo_shield.monitoring = false
	Tempo_shield.monitorable = false
	TS_hitbox.monitoring = false
	TS_hitbox.monitorable = false
	TS_hitbox.visible = false
	
	# Reset animation based on current state
	update_animations()

func _on_tempo_shield_area_entered(area: Area2D) -> void:
	if Is_blocking and area.is_in_group("Projectile"):
		if Is_parrying:
			# Reflect projectile based on Facing_direction
			match Facing_direction:
				"up": area.Direction = Vector2(0, -1)
				"down": area.Direction = Vector2(0, 1)
				"left": area.Direction = Vector2(-1, 0)
				"right": area.Direction = Vector2(1, 0)
			area.Fired_by = self
			print("Projectile parried!")
		else:
			area.Direction *= 0.2  # Slow projectile
			print("Projectile blocked!")

#----------melee related functions----------#
func melee_attack() -> void: 
	Is_attacking = true
	Facing_direction = get_mouse_direction()
	Player_sprite.speed_scale = Used_attack_speed
	find_used_melee_damage()
	
	if Player_sfx and Attack_sound: 
		Player_sfx.stream = Attack_sound
		Player_sfx.play()
		
	update_animations()
	
	var Attack_animation_name : String = Attack + Facing_direction
	var Attack_animation_speed : float = Player_sprite.get_sprite_frames().get_animation_speed(Attack_animation_name)
	var Attack_animation_frames : float = Player_sprite.get_sprite_frames().get_frame_count(Attack_animation_name)
	var Attack_animation_length : float = (Attack_animation_frames / Attack_animation_speed) / Used_attack_speed
	var Attack_frame_speed : float = Attack_animation_length / Attack_animation_frames
	
	var Hurtbox_delay = Attack_frame_speed
	var Hurtbox_duration = Attack_frame_speed * 1
	
	activate_melee_hurtbox(Hurtbox_delay, Hurtbox_duration)
	
	Melee_hurtbox.apply_interval(Attack_animation_length - Attack_frame_speed)
	await get_tree().create_timer(Attack_animation_length - Attack_frame_speed, false, true).timeout
	end_attack_animation()

func end_attack_animation() -> void: 
	Is_attacking = false
	Player_sprite.speed_scale = 1.0

func activate_melee_hurtbox(Delay : float, Duration : float) -> void: 
	await get_tree().create_timer(Delay, false, true).timeout
	Melee_hurtbox.monitoring = true
	var Holder = Successful_hits
	Melee_hurtbox.success_check()
	Melee_hurtbox.visible = true
	
	var Attack_direction2 = null

	if "Spin Sword" in Sword_list:
		Melee_hurtbox.position = Vector2(0,0)
		if Light_sword:
			Light_sword.position = Vector2(0,0)
			Attack_direction2 = use_melee_weapon("",Light_sword.Collision)
			Is_parrying = true
			Light_sword.toggle()
	else:
		Melee_hurtbox.position = get_object_spawn_position(Facing_direction)
		if Light_sword:
			Light_sword.position = get_object_spawn_position(Facing_direction)
			Attack_direction2 = use_melee_weapon("",Light_sword.Collision)
			Is_parrying = true
			Light_sword.toggle()
	
	var Attack_direction = use_melee_weapon("",Melee_collision)		# any shape changes are temporary
	
			# any shape changes are temporary
	
	await get_tree().create_timer(Duration, false, true).timeout
	Melee_hurtbox.monitoring = false
	Melee_hurtbox.visible = false
	
	if "Sword Hate" not in Sword_list or Successful_hits == Holder:# For checking consecutive hits
		Successful_hits = 0

	print("Successful hits: ",Successful_hits)
	print("Damage: ",Used_melee_dmg) 
	use_melee_weapon(Attack_direction,Melee_collision)				# Removed here with the same direction
	
	if Attack_direction2	:
		use_melee_weapon(Attack_direction2,Light_sword.Collision)
		Is_parrying = false
		Light_sword.toggle()

func apply_melee_weapon(Melee_x: int, Melee_y: int, Weapon: String, Equip: bool) -> void:
	if not Equip:
		Sword_list.erase(Weapon)
	else:
		Sword_list.append(Weapon)
	Melee_x_additional += Melee_x
	Melee_y_additional += Melee_y
	
func use_melee_weapon(Direction: String,Collision) -> String:
#	print(Melee_x_additional,", ",Melee_y_additional)
	var Usage = -1
	if not Direction:
		Direction = Facing_direction
		Usage = 1
	var shape = Collision.shape	
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
func shoot_projectile():
	
	if Player_sfx and Ranged_sound: 
		Player_sfx.stream = Ranged_sound
		Player_sfx.play()
		
	Reloading = true
	print("Shooting with spread shot")
	var Total_projectiles = 1 + Spread_shot_count
	var Spread_angle = deg_to_rad(30)
	var Spread_step = Spread_angle / max(1, Total_projectiles - 1)
	var Center_index = Total_projectiles / 2

	for k in range(Multi_shot_count):
		for i in range(Total_projectiles):
			var Projectile_instance = Projectile.instantiate()
			var Angle_offset = (i - Center_index) * Spread_step
			if Total_projectiles % 2 == 0 and i == Center_index:
				Angle_offset = 0.0 
			
			Projectile_instance.Direction = Mouse_direction.rotated(Angle_offset).normalized()
			Projectile_instance.SpawnPos = global_position
			Projectile_instance.Fired_by = self
			Projectile_instance.MaxBounces = Projectile_bounce_count
			Projectile_instance.Lifetime += Live_time_addition
			Projectile_instance.MaxPierce += Pierce_addition
			
			Main = get_tree().current_scene
			if Main:
				Main.add_child(Projectile_instance)
				
			Projectile_instance.implement_damage(Used_projectile_dmg)
		await get_tree().create_timer(0.09).timeout
	reloaded()

func reloaded() -> void:
	await get_tree().create_timer(1/Used_attack_speed).timeout
	Reloading = false

var Timer_dictionary: Dictionary = {}
func set_up_timer(ID: String, Time_amount: float) -> void:
	if Timer_dictionary.has(ID):

		Timer_dictionary[ID].wait_time = 0
		print("Updated timer for ID:", ID, "to time:", Time_amount)
	else:
		# Create new timer
		Timer_dictionary[ID] = Timer.new()
		Timer_dictionary[ID].one_shot = true
		Timer_dictionary[ID].wait_time = 0
		print(Timer_dictionary[ID].wait_time)
		add_child(Timer_dictionary[ID])
		Timer_dictionary[ID].wait_time = 0
		Timer_dictionary[ID].connect("timeout", Callable(self, "_on_parry_timer_timeout").bind(ID))
		print("Timer set up for ID:", ID, "with time:", Time_amount)
	print(Timer_dictionary[ID].wait_time)
func _on_parry_timer_timeout(ID) -> void:
	match ID:
		"016":
			Player_hitbox.monitorable = true
		"017":
			print("Not yet")
			add_percent_melee_damage(-Parry_bonus)
	

func on_projectile_parry() -> void:
	# Example durations (could be parameters or constants)
	print("Parried")
	if Disappear_time > 0:
		if Timer_dictionary.has("016"):
			Timer_dictionary["016"].wait_time = Disappear_time
			if Timer_dictionary["016"].is_stopped():
				Player_hitbox.monitorable = false  # Disable collision layer 2
				Timer_dictionary["016"].start()
			print("Timer 016 reset to:", Disappear_time, "remaining:", Timer_dictionary["016"].time_left)
		else:
			print("Timer 016 not initialized yet!")
	
	if Parry_bonus_time > 0:
		print(Timer_dictionary["017"].wait_time)			
		if Timer_dictionary.has("017"):
			Timer_dictionary["017"].wait_time = Parry_bonus_time
			if Timer_dictionary["017"].is_stopped():
				add_percent_melee_damage(Parry_bonus)  # Add damage bonus
				Timer_dictionary["017"].start()
			print("Timer 017 reset to:", Parry_bonus_time, "remaining:", Timer_dictionary["017"].time_left)
		else:
			print("Timer 017 not initialized yet!")
		

#----------component related functions----------#
func _on_player_health_died() -> void:
	if Player_is_dead:
		return
	Player_is_dead = true
	Player_sprite.play("Death")
	Player_hitbox.monitoring = false
	await Player_sprite.animation_finished
	await get_tree().create_timer(0.5).timeout

func _on_player_health_damage_taken(_Amount: float) -> void:
	var original_color = modulate
	Player_sprite.modulate = Color(1, 0, 0)

	Is_hit = true
	Player_hitbox.monitoring = false
	Player_hitbox.monitorable = false

	await get_tree().create_timer(0.2).timeout
	Player_sprite.modulate = original_color
	Is_hit = false
	Player_hitbox.monitoring = true
	Player_hitbox.monitorable = true
	
func apply_knockback(force: Vector2) -> void:
	knockback_velocity = force
	
func reset_state():
	await get_tree().process_frame
	velocity = Vector2.ZERO
	Input_direction = Vector2.ZERO
	Player_health.Is_dead = false
	Player_is_dead = false
	Player_hitbox.monitoring = true
	Player_health.heal(Player_health.Max_health)
	Can_process_input = true
	Can_process_movement = true
	await get_tree().process_frame
	UIManager.reinitialize_ui()
	var playerinfo = get_node_or_null("UI Wrapper/HUD/PlayerInfo")
	if playerinfo:
		playerinfo.init_elements()
	await get_tree().process_frame
	
	
#----------item related functions----------#
func get_inventory() -> InventoryObject:
	return Inventory

func get_range(Value: int) -> void:
	Has_range = Value

func get_melee(Value: int) -> void:
	Has_melee = Value

func add_successful_hits() -> void:
	Successful_hits += 1

func do_life_steal(Damage_dealt: float) -> void:
	print("Lifesteal: ", Percent_life_steal)
	Player_health.heal(Damage_dealt * Percent_life_steal)

func add_percent_hate_damage(Amount: int) -> void:
	Percent_hate_damage_bonus += (Amount * 0.01)

func toggle_dash(Value: bool) -> void:
	Can_dash = Value

func set_dash_cooldown(Value: float) -> void:
	Dash_cooldown = Value

func toggle_can_attack() -> void:
	Can_attack = !Can_attack
	
func toggle_can_block() -> void:
	Can_block = !Can_block
	
func set_disappear_time(Amount:float) -> void:
	Disappear_time = Amount
func set_parry_bonus(Amount:float) -> void:
	Parry_bonus = Amount
func set_parry_bonus_time(Amount:float) -> void:
	Parry_bonus_time = Amount

func toggle_parry() -> void:
	var bit_5_mask = 1 << 5
	# XOR toggles the bit: if it's 1 it becomes 0, if it's 0 it becomes 1
	Melee_hurtbox.collision_mask = Melee_hurtbox.collision_mask ^ bit_5_mask

func apply_light_sword(Light):	# Applied Light Sword
	Light_sword = Light

#----------status upgrade related functions----------#
func get_effect_manager() -> Node:
	return Effect_manager

func get_curr_upgrade(Stat_name: String) -> int:
	return Upgrade_status_count[Stat_name]

func add_curr_upgrade(Stat_name: String) -> void:
	Upgrade_status_count[Stat_name] += 1

func get_upgrade_counter() -> Dictionary:
	return Upgrade_status_count

#----------get base status functions----------#
func get_max_health() -> float:
	return Base_max_health

func get_melee_damage() -> float:
	return Base_melee_dmg

func get_projectile_damage() -> float:
	return Base_projectile_dmg

func get_attack_speed() -> float:
	return Base_attack_speed

func get_movement_speed() -> float:
	return Base_move_speed

#----------Edit base status functions----------#
func add_max_health(Amount: float) -> void:
	Base_max_health += Amount
	Inventory.update_items()
	find_used_max_health()

func add_melee_damage(Amount: float) -> void:
	Base_melee_dmg += Amount
	Inventory.update_items()
	find_used_melee_damage()

func add_projectile_damage(Amount: float) -> void:
	Base_projectile_dmg += Amount
	Inventory.update_items()
	find_used_projectile_damage()
func add_attack_speed(Amount: float) -> void:
	Base_attack_speed += Amount
	Inventory.update_items()
	find_used_attack_speed()
  
func add_movement_speed(Amount: float) -> void:
	Base_move_speed += Amount
	Inventory.update_items()
	find_used_movement_speed()

func add_incr_max_health(Amount: float) -> void:
	Incr_max_health += Amount
	Inventory.update_items()
	find_used_max_health()

func add_incr_melee_damage(Amount: float) -> void:
	Incr_melee_dmg += Amount
	Inventory.update_items()
	find_used_melee_damage()

func add_incr_projectile_damage(Amount: float) -> void:
	Incr_projectile_dmg += Amount
	Inventory.update_items()
	find_used_projectile_damage()

func add_incr_attack_speed(Amount: float) -> void:
	Incr_attack_speed += Amount
	Inventory.update_items()
	find_used_attack_speed()

func add_incr_movement_speed(Amount: float) -> void:
	Incr_move_speed += Amount
	Inventory.update_items()
	find_used_movement_speed()

func add_percent_max_health(Amount: int) -> void:
	Percent_max_health_bonus += (Amount*0.01)
	Inventory.update_items()
	find_used_max_health()

func add_percent_melee_damage(Amount: int) -> void:
	Percent_melee_damage_bonus += (Amount*0.01)
	print("Percent Melee ", Percent_melee_damage_bonus)
	Inventory.update_items()
	find_used_melee_damage()

func add_percent_range_damage(Amount: int) -> void:
	Percent_Projectile_damage += (Amount*0.01)
	Inventory.update_items()
	find_used_projectile_damage()

func add_percent_movement_speed(Amount: int) -> void:
	Percent_movement_speed_bonus += (Amount*0.01)
	Inventory.update_items()
	find_used_movement_speed()

#----------find used status functions----------#
func find_used_max_health() -> float:
	Used_max_health = (Base_max_health + Incr_max_health) * (1 + Percent_max_health_bonus)
	Player_health.set_new_health(Used_max_health)
	return Used_max_health
	
func find_used_melee_damage() -> float:
	var Used_percent = Percent_melee_damage_bonus + (Percent_hate_damage_bonus * Successful_hits)
	Used_melee_dmg = (Base_melee_dmg + Incr_melee_dmg) * (1 + Used_percent)
	Melee_hurtbox.hurtbox_implement_damage(Used_melee_dmg)
	return Used_melee_dmg

func find_used_projectile_damage() -> float:
	Used_projectile_dmg = (Base_projectile_dmg + Incr_projectile_dmg)* (1 + Percent_Projectile_damage)
	return Used_projectile_dmg
	
func find_used_attack_speed() -> float:
	Used_attack_speed = Base_attack_speed + Incr_attack_speed
	return Used_attack_speed

func find_used_movement_speed() -> float:
	Used_move_speed = (Base_move_speed + Incr_move_speed) * (1+Percent_movement_speed_bonus)
	return Used_move_speed

func add_used_projectile_bounce_count(Amount: int) -> void:
	Projectile_bounce_count += Amount

func add_used_spread_shot_count(Amount: int) -> void:
	Spread_shot_count += Amount

func add_used_multi_shot_count(Amount: int) -> void:
	Multi_shot_count += Amount

func add_used_live_time_addition(Amount: int) -> void:
	Live_time_addition += Amount

func add_used_pierce_addition(Amount: int) -> void:
	Pierce_addition += Amount

func add_used_lifesteal_percent(Amount: int) -> void:
	Percent_life_steal += (Amount * 0.01)

func add_used_damage_reduction_percent(Amount: int) -> void:
	Percent_damage_reduction += (Amount * 0.01)
	Player_hitbox.set_damage_reduction(Percent_damage_reduction)


func _on_melee_hurtbox_hit(enemy_hitbox: HitboxComponent, amount: float) -> void:
	var enemy = enemy_hitbox.get_parent()
	if enemy and enemy.has_method("apply_knockback"):
		var dir = (enemy.global_position - global_position).normalized()
		enemy.apply_knockback(dir * Knockback_strength)
		print("knockback")

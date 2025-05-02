extends CharacterBody2D

# onready variables
@onready var Boss_sprite: AnimatedSprite2D = $BossSprite
@onready var Boss_health: HealthComponent = $BossHealth
@onready var Boss_hitbox: HitboxComponent = $BossHitbox
@onready var Boss_health_bar: ProgressBar = $HealthBar
@onready var Boss_shield_durability: HealthComponent = $BossShield/BossShieldDurability
@onready var Boss_shield_hitbox: HitboxComponent = $BossShield/BossShieldHitbox
@onready var Boss_shield_durability_bar: ProgressBar = $BossShield/BossShieldDurabilityBar
@onready var DashTimer: Timer = $DashTimer
@onready var Boss_los: RayCast2D = $BossLOS
@onready var Wait_timer: Timer = $WaitTimer

@onready var Boss_melee_detection_area: Area2D = $BossMeleeDetectionArea
@onready var Melee_attack: HurtboxComponent = $MeleeAttack

# exportable variables
# movement variables
@export var Speed = 50
@export var Dash_speed = 200
@export var Dash_cooldown : float = 2.0
@export var Dash_duration : float = 0.3
var Last_direction : Vector2 = Vector2.ZERO
var Is_waiting :  bool = false

# shooting variables
@export var Projectile = load("res://Scenes/Objects/Projectile.tscn")
@export var Shoot_timer: float = 0.0  # Tracks time since last attack
@export var Shoot_cooldown: float = 1.0  # Delay between attacks
@export var Rotation_offset: float = 0.0  # Rotation angle for projectile pattern
@export var Rotation_speed: float = 30.0  # Degrees per second to rotate the pattern

# local variables
var Dashing = false
var Dash_direction = Vector2.ZERO
# attacking variables
var Player_in_melee_range: bool = false
var Is_range_attacking : bool = false
var Is_melee_attacking : bool = false
# animation variables
var Current_attack_animation

# player variables
var Player_chase = false
var Player = null

func _ready() -> void:
	# flip boss sprite on default
	#Boss_sprite.flip_h = true
	
	# default animation start
	Boss_sprite.play("Idle")
	Boss_los.enabled = true
	
	# initialize the dash
	DashTimer.wait_time = 1  
	DashTimer.one_shot = false
	DashTimer.timeout.connect(_on_dash_timer_timeout)
	DashTimer.start()
	Wait_timer.timeout.connect(_on_wait_timer_timeout)
	
	#disable hitbox first
	Boss_hitbox.visible = false
	Boss_hitbox.monitorable = false
	Boss_hitbox.monitoring = false
	
	Boss_shield_durability_bar.visible = true
	Boss_health_bar.visible = true
	
	# Setup Boss Light Shield
	if not Boss_sprite.material:
		var material = ShaderMaterial.new()
		material.shader = load("res://Scripts/Enemies/Boss.gdshader")  
		Boss_sprite.material = material
	
	# Setup attacking hurtbox
	Melee_attack.monitoring = false
	Melee_attack.monitorable = false  
	Melee_attack.visible = false 
	
func _physics_process(delta: float) -> void:
	if !is_dead():
		# check shield activity
		is_shield_active()
		
		# this is essential for moving CharacterBodies
		if Dashing:
			velocity = Dash_direction * Dash_speed
			move_and_collide(velocity * delta)
			return
		
		# default moving without dash
		move_and_collide(velocity * delta)
		
		# Required to start shooting the player
		Shoot_timer += delta
		
		# Handle line of sight check if player is detected
		if Player != null and !Is_waiting:
			# Point the RayCast2D towards the player
			Boss_los.target_position = Player.global_position - global_position
			# Force update to get immediate collision result
			Boss_los.force_raycast_update()
			# Check if RayCast2D hits the player directly
			if Boss_los.is_colliding() and Boss_los.get_collider() == Player:
				Player_chase = true
				Last_direction = (Player.position - position).normalized()
			else:
				Player_chase = false
		
		if Player_chase:
			# chases the player
			var Direction = (Player.position - position).normalized()
			velocity = Direction * Speed
			
			# melee attacks
			if Player_in_melee_range and !Is_melee_attacking:
				start_melee_attack()
			
			# circular saw attack
			if Shoot_timer >= Shoot_cooldown and !Player_in_melee_range and !Is_range_attacking:
				Is_range_attacking = true
				start_ranged_attack()
				await get_tree().create_timer(1.0).timeout
			
			# Rotate the pattern over time
			Rotation_offset += Rotation_speed * delta
			Rotation_offset = fmod(Rotation_offset, 360.0)  # Keep within 0-360 degrees
			
			# Flip sprite based on player position and current animation
			var player_is_left = Player.position.x < position.x
			if Boss_sprite.animation == "Charge":
				Boss_sprite.flip_h = not player_is_left
			else:
				if Is_range_attacking or Is_melee_attacking:
					if Current_attack_animation == "":
						Boss_sprite.flip_h = not player_is_left
					else:
						Boss_sprite.flip_h = player_is_left
				else:
					Boss_sprite.flip_h = not player_is_left
		
		elif Is_waiting:
			# Move in last direction during waiting period
			velocity = Last_direction * Speed
		
		else:
			velocity = Vector2.ZERO
			
		update_animations()
	else:
		enemy_dead()

func start_ranged_attack() -> void:
	Current_attack_animation = "RangedAttack"
	update_animations()
	# Wait for animation to finish
	var Attack_animation_name : String = Current_attack_animation
	var Attack_animation_speed : float = Boss_sprite.get_sprite_frames().get_animation_speed(Attack_animation_name)
	var Attack_animation_frames : float = Boss_sprite.get_sprite_frames().get_frame_count(Attack_animation_name)
	var Attack_animation_length : float = (Attack_animation_frames / Attack_animation_speed)
	var Attack_frame_speed : float = Attack_animation_length / Attack_animation_frames
	
	await get_tree().create_timer(Attack_animation_length - Attack_frame_speed, false, true).timeout
	# shoot projectiles
	circle_attack()
	Shoot_timer = 0.0
	Shoot_cooldown = 1.0 + randf() * 2.0  # Random cooldown between 1 to 3 seconds
	
	Is_range_attacking = false
	Current_attack_animation = ""

func start_melee_attack():
	var attack_choice = randi() % 2
	
	Is_melee_attacking = true
	attack_choice = randi() % 2
	
	if attack_choice == 0: # beyblade
		Current_attack_animation = "Beyblade"
		Boss_sprite.play(Current_attack_animation)
		Melee_attack.Damage_amount = 20
		Melee_attack.monitoring = true
		Melee_attack.monitorable = true
		Melee_attack.visible = true
		
		var Attack_animation_name : String = Current_attack_animation
		var Attack_animation_speed : float = Boss_sprite.get_sprite_frames().get_animation_speed(Attack_animation_name)
		var Attack_animation_frames : float = Boss_sprite.get_sprite_frames().get_frame_count(Attack_animation_name)
		var Attack_animation_length : float = (Attack_animation_frames / Attack_animation_speed)
		var Attack_frame_speed : float = Attack_animation_length / Attack_animation_frames
		
		await get_tree().create_timer(Attack_animation_length - Attack_frame_speed, false, true).timeout
		
		Melee_attack.monitoring = false
		Melee_attack.monitorable = false
		Melee_attack.visible = false
		
		# Dash away from player
		if Player:
			Dash_direction = (position - Player.position).normalized()
			Dashing = true
			await get_tree().create_timer(Dash_duration).timeout
			Dashing = false
		
	else: # charge
		Current_attack_animation = "Charge"
		Boss_sprite.play(Current_attack_animation)
		
		if Boss_sprite.frame == 0: 
			#Boss_sprite.playing = false
			Boss_sprite.pause()
			
		var pause_duration = randf_range(1.0, 3.0)
		await get_tree().create_timer(pause_duration).timeout
		
		#Boss_sprite.playing = true
		Boss_sprite.play()
		
		Melee_attack.Damage_amount = 50
		Melee_attack.monitoring = true
		Melee_attack.monitorable = true
		Melee_attack.visible = true
		
		var Attack_animation_name : String = Current_attack_animation
		var Attack_animation_speed : float = Boss_sprite.get_sprite_frames().get_animation_speed(Attack_animation_name)
		var Attack_animation_frames : float = Boss_sprite.get_sprite_frames().get_frame_count(Attack_animation_name)
		var Attack_animation_length : float = (Attack_animation_frames / Attack_animation_speed)
		var Attack_frame_speed : float = Attack_animation_length / Attack_animation_frames
		
		await get_tree().create_timer(Attack_animation_length - Attack_frame_speed, false, true).timeout
		
		Melee_attack.monitoring = false
		Melee_attack.monitorable = false
		Melee_attack.visible = false

	Current_attack_animation = ""
	update_animations() # should go back to regular animations again
	
	var random_wait = 1.0 + randf() * 2.0
	await get_tree().create_timer(random_wait).timeout
	
	Is_melee_attacking = false
	await get_tree().create_timer(1.0).timeout

func activate_melee_hurtbox(Delay : float, Duration : float) -> void: 
	await get_tree().create_timer(Delay, false, true).timeout
	Melee_attack.monitoring = true
	Melee_attack.monitorable = true
	Melee_attack.visible = true
	await get_tree().create_timer(Duration, false, true).timeout
	Melee_attack.monitoring = false
	Melee_attack.monitorable = false  
	Melee_attack.visible = false 

func update_animations() -> void:
	if Is_range_attacking or Is_melee_attacking and Current_attack_animation != "":
		if Boss_sprite.animation != Current_attack_animation:
			Boss_sprite.play(Current_attack_animation)
	elif velocity != Vector2.ZERO:
		Boss_sprite.play("Move")
	else:
		Boss_sprite.play("Idle")

func is_shield_active() -> void: 
	if Boss_shield_durability.Health <= 0: 
		Boss_shield_hitbox.visible = false
		Boss_shield_hitbox.monitoring = false
		Boss_shield_hitbox.monitorable = false
		Boss_hitbox.visible = true
		Boss_hitbox.monitorable = true
		Boss_hitbox.monitoring = true
		if Boss_sprite.material:
			Boss_sprite.material.set_shader_parameter("draw_outline", false)
	else:
		Boss_shield_hitbox.visible = true
		Boss_shield_hitbox.monitoring = true
		Boss_shield_hitbox.monitorable = true
		Boss_hitbox.visible = false
		Boss_hitbox.monitorable = false
		Boss_hitbox.monitoring = false
		if Boss_sprite.material:
			Boss_sprite.material.set_shader_parameter("draw_outline", true)

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Player = body
		print("Are you ready to die?")
		if Is_waiting:
			Is_waiting = false
			Wait_timer.stop()
		DashTimer.start()

func _on_detection_area_body_exited(_body: Node2D) -> void:
	if _body == Player and Player_chase:
		Is_waiting = true
		Player_chase = false
		Wait_timer.start()
		Dashing = false
		DashTimer.stop()

func _on_dash_timer_timeout():
	if Player_chase and Player:
		Dash_direction = (Player.position - position).normalized()
		Dashing = true
		await get_tree().create_timer(Dash_duration).timeout
		Dashing = false
		DashTimer.start(Dash_cooldown)

func _on_wait_timer_timeout() -> void:
	if Is_waiting:
		Is_waiting = false
		Player = null
		print("Come back here Coward!")

func shoot_projectile() -> void: 
	var Direction = (Player.position - position).normalized()
	var ProjectileInstance = Projectile.instantiate()
	ProjectileInstance.Direction = Direction.normalized()  
	ProjectileInstance.SpawnPos = global_position
	ProjectileInstance.Fired_by = self
	get_parent().add_child.call_deferred(ProjectileInstance)

func circle_attack():
	var Num_projectiles = 8
	var Angle_step = TAU / Num_projectiles  
	var Angle_offset = deg_to_rad(Rotation_offset)
	for i in range(Num_projectiles):
		var Angle = i * Angle_step + Angle_offset
		var Direction = Vector2(cos(Angle), sin(Angle))
		var ProjectileInstance = Projectile.instantiate()
		ProjectileInstance.Direction = Direction.normalized()  
		ProjectileInstance.Lifetime = 5.0
		ProjectileInstance.SpawnPos = global_position
		ProjectileInstance.Fired_by = self
		ProjectileInstance.MaxBounces = 1
		get_parent().add_child.call_deferred(ProjectileInstance)

func is_dead() -> bool: 
	return Boss_health.Health <= 0

func enemy_dead() -> void:
	Boss_sprite.play("Death")
	Boss_hitbox.monitoring = false
	var Death_animation_name : String = "Death"
	var Death_animation_speed : float = Boss_sprite.get_sprite_frames().get_animation_speed(Death_animation_name)
	var Death_animation_frames : float = Boss_sprite.get_sprite_frames().get_frame_count(Death_animation_name)
	var Death_animation_length : float = (Death_animation_frames / Death_animation_speed)
	var Death_frame_speed : float = Death_animation_length / Death_animation_frames
	await get_tree().create_timer(Death_animation_length - Death_frame_speed, false, true).timeout
	queue_free()

func _on_boss_melee_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Player_in_melee_range = true
		if Is_range_attacking: 
			Is_range_attacking = false

func _on_boss_melee_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Player_in_melee_range = false

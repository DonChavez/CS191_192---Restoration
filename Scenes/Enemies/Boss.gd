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
# movemovent variables
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
				# Optional debug print
				# print("I see you!")
			else:
				Player_chase = false
				# print("Where are you?!")
		
		if Player_chase:
			# chases the player
			var Direction = (Player.position - position).normalized()
			velocity = Direction * Speed
			
			# circular saw attack
			if Shoot_timer >= Shoot_cooldown and !Player_in_melee_range and !Is_range_attacking:
				#Is_attacking = true
					##Boss_sprite.play("RangedAttack")
					## flip animation if player is on the left
					##Boss_sprite.flip_h = Player.position.x < position.x
				#Current_attack_animation = "RangedAttack"
				#await Boss_sprite.animation_finished
				#update_animations()
				#circle_attack() # circular saw attack only activates if the player is outside the boss's melee range
				#Shoot_timer = 0.0
				#Is_attacking = false
				#update_animations()
				Is_range_attacking = true
				start_ranged_attack()
				# Add 1-second delay after animation
				await get_tree().create_timer(1.0).timeout
				#Is_range_attacking = true
				#Current_attack_animation = "RangedAttack"
				#Boss_sprite.play(Current_attack_animation)
				##update_animations()
				#Is_range_attacking = false
				#Shoot_timer = 0.0
			
			#if Player_in_melee_range and !Is_melee_attacking:
				#Is_melee_attacking = true
				##start_melee_attack()
				#beyblade()
				##Current_attack_animation = "Charge"
				##update_animations()
				#Is_melee_attacking = false
				## Add 1-second delay after animation
				##await get_tree().create_timer(1.0).timeout
			
			# Rotate the pattern over time
			Rotation_offset += Rotation_speed * delta
			Rotation_offset = fmod(Rotation_offset, 360.0)  # Keep within 0-360 degrees
			
			# flip animation if player is on the right
			Boss_sprite.flip_h = Player.position.x > position.x
		
		elif Is_waiting:
			# Move in last direction during waiting period
			velocity = Last_direction * Speed
			#Boss_sprite.flip_h = Last_direction.x > 0
		
		else:
			velocity = Vector2.ZERO
			
		update_animations()
	else:
		enemy_dead()

func start_ranged_attack() -> void:
	Current_attack_animation = "RangedAttack"
	#Boss_sprite.play(Current_attack_animation)
	# flip animation 
	Boss_sprite.flip_h = position.x > 0 # bugged
	update_animations()
	# Wait for animation to finish
	# animation length determines how long the attack animation plays for
	var Attack_animation_name : String = Current_attack_animation
	var Attack_animation_speed : float = Boss_sprite.get_sprite_frames().get_animation_speed(Attack_animation_name) # the speed in which the whole animation plays out
	var Attack_animation_frames : float = Boss_sprite.get_sprite_frames().get_frame_count(Attack_animation_name) # the nmumber of frames in the animation
	var Attack_animation_length : float = (Attack_animation_frames / Attack_animation_speed) # the length of the whole animation
	var Attack_frame_speed : float = Attack_animation_length / Attack_animation_frames # the duration of each frame
	
	await get_tree().create_timer(Attack_animation_length - Attack_frame_speed, false, true).timeout
	# shoot projectiles
	circle_attack()
	Shoot_timer = 0.0
	
	Is_range_attacking = false
	Current_attack_animation = ""

func start_melee_attack():
	var attack_choice = randi() % 2  # Random 0 or 1
	
	if attack_choice == 0:
		beyblade()
	else:
		charge()
	
	Is_melee_attacking = false
	Current_attack_animation = ""

func beyblade() -> void:
	Current_attack_animation = "Beyblade"
	Melee_attack.Damage_amount = 20
	
	update_animations()
	
	# animation length determines how long the attack animation plays for
	#var Attack_animation_name : String = Current_attack_animation
	#var Attack_animation_speed : float = Boss_sprite.get_sprite_frames().get_animation_speed(Attack_animation_name) # the speed in which the whole animation plays out
	#var Attack_animation_frames : float = Boss_sprite.get_sprite_frames().get_frame_count(Attack_animation_name) # the nmumber of frames in the animation
	#var Attack_animation_length : float = (Attack_animation_frames / Attack_animation_speed) # the length of the whole animation
	#var Attack_frame_speed : float = Attack_animation_length / Attack_animation_frames # the duration of each frame
	#var Hurtbox_delay = Attack_frame_speed
	#var Hurtbox_duration = Attack_frame_speed * 1 # based on the animations, the attack part of the sprite plays for 1 frames
	#
	## call activate the melee hurtbox
	#activate_melee_hurtbox(Hurtbox_delay, Hurtbox_duration)
		#
	#await get_tree().create_timer(Attack_animation_length - Attack_frame_speed, false, true).timeout
	
func charge() -> void: 
	Current_attack_animation = "Charge"
	
	Melee_attack.Damage_amount = 50
	
	update_animations()
	
	# animation length determines how long the attack animation plays for
	var Attack_animation_name : String = Current_attack_animation
	var Attack_animation_speed : float = Boss_sprite.get_sprite_frames().get_animation_speed(Attack_animation_name) # the speed in which the whole animation plays out
	var Attack_animation_frames : float = Boss_sprite.get_sprite_frames().get_frame_count(Attack_animation_name) # the nmumber of frames in the animation
	var Attack_animation_length : float = (Attack_animation_frames / Attack_animation_speed) # the length of the whole animation
	var Attack_frame_speed : float = Attack_animation_length / Attack_animation_frames # the duration of each frame
	var Hurtbox_delay = Attack_frame_speed
	var Hurtbox_duration = Attack_frame_speed * 1 # based on the animations, the attack part of the sprite plays for 1 frames
	
	# 0.5 second pause before attack
	await get_tree().create_timer(0.5).timeout
	
	# call activate the melee hurtbox
	activate_melee_hurtbox(Hurtbox_delay, Hurtbox_duration)
		
	await get_tree().create_timer(Attack_animation_length - Attack_frame_speed, false, true).timeout

func activate_melee_hurtbox(Delay : float, Duration : float) -> void: 
	# wait for the attack animation to swing the sword
	await get_tree().create_timer(Delay, false, true).timeout
	# activate the meleehurtbox
	# monitoring allows the hurtbox to exist functionally
	# visible allows to see the hurtbox appear
	Melee_attack.monitoring = true
	Melee_attack.monitorable = true
	Melee_attack.visible = true
	
	# Disable after a short duration
	await get_tree().create_timer(Duration, false, true).timeout
	Melee_attack.monitoring = false
	Melee_attack.monitorable = false  
	Melee_attack.visible = false 

func update_animations() -> void:
	if Is_range_attacking or Is_melee_attacking:
		Boss_sprite.play(Current_attack_animation)
	elif velocity != Vector2.ZERO:
		# Adjust animation speed based on movement speed
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
	# whatever enters the detection area is set to body
	# since only the player collides with this detection area, we set the body as the player
	#Player = body
	## enemy will now chase the player
	#Player_chase = true
	if body.is_in_group("Player"):
		Player = body
		print("Are you ready to die?")
		if Is_waiting:
			Is_waiting = false # reset timer 
			Wait_timer.stop()
		DashTimer.start()  # Optional: start the dash timer upon seeing the player

func _on_detection_area_body_exited(_body: Node2D) -> void:
	# we want to stop chasing the player once they exit
	if _body == Player and Player_chase:
		# Player left the detection area; start 5-second movement
		Is_waiting = true
		Player_chase = false
		Wait_timer.start()
		Dashing = false
		DashTimer.stop()  # Optional: pause timer when not chasing
	#Player = null
	#Player_chase = false
	#Dashing = false
	#DashTimer.stop()  # Optional: pause timer when not chasing

func _on_dash_timer_timeout():
	if Player_chase and Player:
		# Enemy dashes to player
		Dash_direction = (Player.position - position).normalized()
		Dashing = true
		# how long the dash is
		await get_tree().create_timer(Dash_duration).timeout
		Dashing = false
		# timeout before the enemy gets to dash again
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
	ProjectileInstance.SpawnPos = global_position  # Use spawnPos like the player does
	ProjectileInstance.Fired_by = self

	get_parent().add_child.call_deferred(ProjectileInstance)  # Ensure it spawns properly

func circle_attack():
	var Num_projectiles = 8
	var Angle_step = TAU / Num_projectiles  
	var Angle_offset = deg_to_rad(Rotation_offset)  # Convert rotation offset to radians

	for i in range(Num_projectiles):
		var Angle = i * Angle_step + Angle_offset
		var Direction = Vector2(cos(Angle), sin(Angle))

		var ProjectileInstance = Projectile.instantiate()
		ProjectileInstance.Direction = Direction.normalized()  
		ProjectileInstance.Lifetime = 5.0
		ProjectileInstance.SpawnPos = global_position  # Use spawnPos like the player does
		ProjectileInstance.Fired_by = self
		ProjectileInstance.MaxBounces = 1  # Ricochets 1 time

		get_parent().add_child.call_deferred(ProjectileInstance)  # Ensure it spawns properly

func is_dead() -> bool: 
	return Boss_health.Health <= 0

func enemy_dead() -> void:
	# playd death animation
	Boss_sprite.play("Death")
	# ensure enemy doesn't take more damage
	Boss_hitbox.monitoring = false
	
	#-------Death Animation Handling-------#
	# same method as seen in the player
	var Death_animation_name : String = "Death"
	var Death_animation_speed : float = Boss_sprite.get_sprite_frames().get_animation_speed(Death_animation_name) # the speed in which the whole animation plays out
	var Death_animation_frames : float = Boss_sprite.get_sprite_frames().get_frame_count(Death_animation_name) # the nmumber of frames in the animation
	var Death_animation_length : float = (Death_animation_frames / Death_animation_speed) # the length of the whole animation
	var Death_frame_speed : float = Death_animation_length / Death_animation_frames # the duration of each frame
	
	# wait for the death animation to finish playing
	await get_tree().create_timer(Death_animation_length - Death_frame_speed, false, true).timeout
	#-------Death Animation Handling-------#
	
	queue_free()

func _on_boss_melee_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Player_in_melee_range = true
		if Is_range_attacking: 
			Is_range_attacking = false

func _on_boss_melee_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Player_in_melee_range = false

extends CharacterBody2D

# onready variables
@onready var Boss_sprite: AnimatedSprite2D = $BossSprite
@onready var Boss_health: HealthComponent = $BossHealth
@onready var Boss_hitbox: HitboxComponent = $BossHitbox
@onready var Boss_shield_durability: HealthComponent = $BossShield/BossShieldDurability
@onready var Boss_shield_hitbox: HitboxComponent = $BossShield/BossShieldHitbox
@onready var DashTimer: Timer = $DashTimer
@onready var Boss_los: RayCast2D = $BossLOS
@onready var Wait_timer: Timer = $WaitTimer

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

# player variables
var Player_chase = false
var Player = null

func _ready() -> void:
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
			Boss_sprite.play("Move")
			
			# shoot the player
			if Shoot_timer >= Shoot_cooldown:
				shoot_projectile()
				circle_attack()
				Shoot_timer = 0.0
			
			# Rotate the pattern over time
			Rotation_offset += Rotation_speed * delta
			Rotation_offset = fmod(Rotation_offset, 360.0)  # Keep within 0-360 degrees
			
			# flip animation if player is on the left
			Boss_sprite.flip_h = Player.position.x < position.x
		
		elif Is_waiting:
			# Move in last direction during waiting period
			velocity = Last_direction * Speed
			Boss_sprite.play("Move")
			Boss_sprite.flip_h = Last_direction.x < 0
		
		else:
			Boss_sprite.play("Idle")
			velocity = Vector2.ZERO
	else:
		enemy_dead()

func is_shield_active() -> void: 
	if Boss_shield_durability.Health <= 0: 
		Boss_shield_hitbox.visible = false
		Boss_shield_hitbox.monitoring = false
		Boss_shield_hitbox.monitorable = false
		
		Boss_hitbox.visible = true
		Boss_hitbox.monitorable = true
		Boss_hitbox.monitoring = true

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

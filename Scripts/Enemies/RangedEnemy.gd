extends CharacterBody2D

# onready variables
@onready var Ranged_sprite: AnimatedSprite2D = $RangedEnemySprite
@onready var Ranged_health: HealthComponent = $RangedEnemyHealth
@onready var Ranged_hitbox: HitboxComponent = $RangedEnemyHitbox
@onready var Ranged_los: RayCast2D = $RangedLOS
@onready var Wait_timer: Timer = $WaitTimer

# exportable variables
@export var Projectile = load("res://Scenes/Objects/Projectile.tscn")

# Attack variables
@export var Attack_timer: float = 0.0  # Tracks time since last attack
@export var Attack_cooldown: float = 1.0  # Delay between attacks

# movemovent variables
var Speed = 50
var Last_direction : Vector2 = Vector2.ZERO
var Is_waiting :  bool = false

# player variables
var Player_chase = false
var Player = null

func _ready() -> void:
	# default animation start
	Ranged_sprite.play("Idle")
	Ranged_los.enabled = true
	Wait_timer.timeout.connect(_on_wait_timer_timeout)

func _physics_process(delta: float) -> void:
	if !is_dead():
		# this is essential for moving CharacterBodies
		move_and_collide(velocity * delta)
		
		# Required to start shooting the player
		Attack_timer += delta
		
		# Handle line of sight check if player is detected
		if Player != null and !Is_waiting:
			# Point the RayCast2D towards the player
			Ranged_los.target_position = Player.global_position - global_position
			# Force update to get immediate collision result
			Ranged_los.force_raycast_update()
			# Check if RayCast2D hits the player directly
			if Ranged_los.is_colliding() and Ranged_los.get_collider() == Player:
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
			Ranged_sprite.play("Move")
			
			# shoot the player
			if Attack_timer >= Attack_cooldown:
				shoot_projectile()
				Attack_timer = 0.0
			
			# flip animation if player is on the left
			Ranged_sprite.flip_h = Player.position.x > position.x
		
		elif Is_waiting:
			# Move in last direction during waiting period
			velocity = Last_direction * Speed
			Ranged_sprite.play("Move")
			#Ranged_sprite.flip_h = Last_direction.x < 0
			
		else:
			Ranged_sprite.play("Idle")
			velocity = Vector2.ZERO
	else:
		enemy_dead()


func _on_detection_area_body_entered(body: Node2D) -> void:
	# whatever enters the detection area is set to body
	# since only the player collides with this detection area, we set the body as the player
	#Player = body
	## enemy will now chase the player
	#Player_chase = true
	if body.is_in_group("Player"):
		Player = body
		print("Enemy on sight")
		if Is_waiting:
			Is_waiting = false # reset timer 
			Wait_timer.stop()

func _on_detection_area_body_exited(_body: Node2D) -> void:
	# we want to stop chasing the player once they exit
	#Player = null
	#Player_chase = false
	if _body == Player and Player_chase:
		# Player left the detection area; start 10-second movement
		Is_waiting = true
		Player_chase = false
		Wait_timer.start()

func _on_wait_timer_timeout() -> void:
	if Is_waiting:
		Is_waiting = false 
		Player = null
		print("Bravo six going dark")

func shoot_projectile() -> void: 
	var Direction = (Player.position - position).normalized()
	
	var ProjectileInstance = Projectile.instantiate()
	ProjectileInstance.Direction = Direction.normalized()  
	ProjectileInstance.SpawnPos = global_position  # Use spawnPos like the player does
	ProjectileInstance.Fired_by = self

	get_parent().add_child.call_deferred(ProjectileInstance)  # Ensure it spawns properly

func is_dead() -> bool: 
	return Ranged_health.Health <= 0

func enemy_dead() -> void:
	# playd death animation
	Ranged_sprite.play("Death")
	# ensure enemy doesn't take more damage
	Ranged_hitbox.monitoring = false
	
	#-------Death Animation Handling-------#
	# same method as seen in the player
	var Death_animation_name : String = "Death"
	var Death_animation_speed : float = Ranged_sprite.get_sprite_frames().get_animation_speed(Death_animation_name) # the speed in which the whole animation plays out
	var Death_animation_frames : float = Ranged_sprite.get_sprite_frames().get_frame_count(Death_animation_name) # the nmumber of frames in the animation
	var Death_animation_length : float = (Death_animation_frames / Death_animation_speed) # the length of the whole animation
	var Death_frame_speed : float = Death_animation_length / Death_animation_frames # the duration of each frame
	
	# wait for the death animation to finish playing
	await get_tree().create_timer(Death_animation_length - Death_frame_speed, false, true).timeout
	#-------Death Animation Handling-------#
	
	queue_free()

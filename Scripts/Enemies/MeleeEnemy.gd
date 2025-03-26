extends CharacterBody2D

# onready variables
@onready var Melee_sprite: AnimatedSprite2D = $MeleeEnemySprite
@onready var Melee_health: HealthComponent = $MeleeEnemyHealth
@onready var Melee_hitbox: HitboxComponent = $MeleeEnemyHitbox
@onready var DashTimer: Timer = $DashTimer
@onready var Melee_los: RayCast2D = $MeleeLOS
@onready var Wait_timer: Timer = $WaitTimer

# exportable variables
# movemovent variables
@export var Speed = 50
@export var Dash_speed = 200
@export var Dash_cooldown : float = 2.0
@export var Dash_duration : float = 0.3
var Last_direction : Vector2 = Vector2.ZERO
var Is_waiting :  bool = false

# local variables
var Dashing = false
var Dash_direction = Vector2.ZERO

# player variables
var Player_chase = false
var Player = null

func _ready() -> void:
	# default animation start
	Melee_sprite.play("Idle")
	Melee_los.enabled = true
	
	# initialize the dash
	DashTimer.wait_time = 1  
	DashTimer.one_shot = false
	DashTimer.timeout.connect(_on_dash_timer_timeout)
	DashTimer.start()
	Wait_timer.timeout.connect(_on_wait_timer_timeout)

func _physics_process(delta: float) -> void:
	if !is_dead():
		# this is essential for moving CharacterBodies
		
		if Dashing:
			velocity = Dash_direction * Dash_speed
			move_and_collide(velocity * delta)
			return
		
		# Handle line of sight check if player is detected
		if Player != null and !Is_waiting:
			# Point the RayCast2D towards the player
			Melee_los.target_position = Player.global_position - global_position
			# Force update to get immediate collision result
			Melee_los.force_raycast_update()
			# Check if RayCast2D hits the player directly
			if Melee_los.is_colliding() and Melee_los.get_collider() == Player:
				Player_chase = true
				Last_direction = (Player.position - position).normalized()
				# Optional debug print
				# print("I see you!")
			else:
				Player_chase = false
				# print("Where are you?!")
		
		# default moving without dash
		move_and_collide(velocity * delta)
		
		if Player_chase:
			# chases the player
			var Direction = (Player.position - position).normalized()
			velocity = Direction * Speed
			Melee_sprite.play("Move")
			
			# flip animation if player is on the left
			Melee_sprite.flip_h = Player.position.x < position.x
			
		elif Is_waiting:
			# Move in last direction during waiting period
			velocity = Last_direction * Speed
			Melee_sprite.play("Move")
			Melee_sprite.flip_h = Last_direction.x < 0
			
		else:
			Melee_sprite.play("Idle")
			velocity = Vector2.ZERO
	else:
		enemy_dead()


func _on_detection_area_body_entered(body: Node2D) -> void:
	# whatever enters the detection area is set to body
	# since only the player collides with this detection area, we set the body as the player
	#Player = body
	## enemy will now chase the player
	#Player_chase = true
	#print("URRARRUU!")
	#DashTimer.start()  # Optional: start the dash timer upon seeing the player
	if body.is_in_group("Player"):
		Player = body
		print("URRARRUU!")
		if Is_waiting:
			Is_waiting = false # reset timer 
			Wait_timer.stop()
		DashTimer.start()

func _on_detection_area_body_exited(_body: Node2D) -> void:
	# we want to stop chasing the player once they exit
	if _body == Player and Player_chase:
		# Player left the detection area; start 5-second movement
		Is_waiting = true
		Player_chase = false
		Wait_timer.start()
		Dashing = false
		DashTimer.stop()  # Optional: pause timer when not chasing

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
		print("Que?")

func is_dead() -> bool: 
	return Melee_health.Health <= 0

func enemy_dead() -> void:
	# playd death animation
	Melee_sprite.play("Death")
	# ensure enemy doesn't take more damage
	Melee_hitbox.monitoring = false
	
	#-------Death Animation Handling-------#
	# same method as seen in the player
	var Death_animation_name : String = "Death"
	var Death_animation_speed : float = Melee_sprite.get_sprite_frames().get_animation_speed(Death_animation_name) # the speed in which the whole animation plays out
	var Death_animation_frames : float = Melee_sprite.get_sprite_frames().get_frame_count(Death_animation_name) # the nmumber of frames in the animation
	var Death_animation_length : float = (Death_animation_frames / Death_animation_speed) # the length of the whole animation
	var Death_frame_speed : float = Death_animation_length / Death_animation_frames # the duration of each frame
	
	# wait for the death animation to finish playing
	await get_tree().create_timer(Death_animation_length - Death_frame_speed, false, true).timeout
	#-------Death Animation Handling-------#
	
	queue_free()

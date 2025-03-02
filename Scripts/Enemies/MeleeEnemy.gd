extends CharacterBody2D

# onready variables
@onready var Melee_sprite: AnimatedSprite2D = $MeleeEnemySprite
@onready var Melee_health: HealthComponent = $MeleeEnemyHealth
@onready var Melee_hitbox: HitboxComponent = $MeleeEnemyHitbox
@onready var DashTimer: Timer = $DashTimer

# exportable variables
# movemovent variables
@export var Speed = 50
@export var Dash_speed = 200
@export var Dash_cooldown : float = 2.0
@export var Dash_duration : float = 0.3

# local variables
var Dashing = false
var Dash_direction = Vector2.ZERO

# player variables
var Player_chase = false
var Player = null

func _ready() -> void:
	# default animation start
	Melee_sprite.play("Idle")
	
	# initialize the dash
	DashTimer.wait_time = 1  
	DashTimer.one_shot = false
	DashTimer.timeout.connect(_on_dash_timer_timeout)
	DashTimer.start()

func _physics_process(delta: float) -> void:
	if !is_dead():
		# this is essential for moving CharacterBodies
		
		if Dashing:
			velocity = Dash_direction * Dash_speed
			move_and_collide(velocity * delta)
			return
		
		# default moving without dash
		move_and_collide(velocity * delta)
		
		if Player_chase:
			# chases the player
			var Direction = (Player.position - position).normalized()
			velocity = Direction * Speed
			Melee_sprite.play("Move")
			
			# flip animation if player is on the left
			Melee_sprite.flip_h = Player.position.x < position.x
			
		else:
			Melee_sprite.play("Idle")
			velocity = Vector2.ZERO
	else:
		enemy_dead()


func _on_detection_area_body_entered(body: Node2D) -> void:
	# whatever enters the detection area is set to body
	# since only the player collides with this detection area, we set the body as the player
	Player = body
	# enemy will now chase the player
	Player_chase = true
	print("URRARRUU!")
	DashTimer.start()  # Optional: start the dash timer upon seeing the player

func _on_detection_area_body_exited(body: Node2D) -> void:
	# we want to stop chasing the player once they exit
	Player = null
	Player_chase = false
	print("Que?")
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

extends CharacterBody2D

# onready variables
@onready var BE_sprite: AnimatedSprite2D = $BasicEnemySprite
@onready var BE_health: HealthComponent = $BasicEnemyHealth
@onready var BE_hitbox: HitboxComponent = $BasicEnemyHitbox

# movemovent variables
var Speed = 50

# player variables
var Player_chase = false
var Player = null

func _ready() -> void:
	# default animation start
	BE_sprite.play("Idle")

func _physics_process(delta: float) -> void:
	if !is_dead():
		# this is essential for moving CharacterBodies
		move_and_collide(velocity * delta)
		
		if Player_chase:
			# chases the player
			var Direction = (Player.position - position).normalized()
			velocity = Direction * Speed
			BE_sprite.play("Move")
			
			# flip animation if player is on the left
			BE_sprite.flip_h = Player.position.x < position.x
			
		else:
			BE_sprite.play("Idle")
			velocity = Vector2.ZERO
	else:
		enemy_dead()


func _on_detection_area_body_entered(body: Node2D) -> void:
	# whatever enters the detection area is set to body
	# since only the player collides with this detection area, we set the body as the player
	Player = body
	# enemy will now chase the player
	Player_chase = true
	print("I see you!")

func _on_detection_area_body_exited(body: Node2D) -> void:
	# we want to stop chasing the player once they exit
	Player = null
	Player_chase = false
	print("Wait a minute... who are you?")

func is_dead() -> bool: 
	return BE_health.Health <= 0

func enemy_dead() -> void:
	# playd death animation
	BE_sprite.play("Death")
	# ensure enemy doesn't take more damage
	BE_hitbox.monitoring = false
	
	#-------Death Animation Handling-------#
	# same method as seen in the player
	var Death_animation_name : String = "Death"
	var Death_animation_speed : float = BE_sprite.get_sprite_frames().get_animation_speed(Death_animation_name) # the speed in which the whole animation plays out
	var Death_animation_frames : float = BE_sprite.get_sprite_frames().get_frame_count(Death_animation_name) # the nmumber of frames in the animation
	var Death_animation_length : float = (Death_animation_frames / Death_animation_speed) # the length of the whole animation
	var Death_frame_speed : float = Death_animation_length / Death_animation_frames # the duration of each frame
	
	# wait for the death animation to finish playing
	await get_tree().create_timer(Death_animation_length - Death_frame_speed, false, true).timeout
	#-------Death Animation Handling-------#
	
	queue_free()

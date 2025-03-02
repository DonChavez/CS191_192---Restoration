extends CharacterBody2D

# onready variables
@onready var Ranged_sprite: AnimatedSprite2D = $RangedEnemySprite
@onready var Ranged_health: HealthComponent = $RangedEnemyHealth
@onready var Ranged_hitbox: HitboxComponent = $RangedEnemyHitbox

# exportable variables
@export var Projectile = load("res://Scenes/Objects/Projectile.tscn")

# Attack variables
@export var Attack_timer: float = 0.0  # Tracks time since last attack
@export var Attack_cooldown: float = 1.0  # Delay between attacks

# movemovent variables
var Speed = 50

# player variables
var Player_chase = false
var Player = null

func _ready() -> void:
	# default animation start
	Ranged_sprite.play("Idle")

func _physics_process(delta: float) -> void:
	if !is_dead():
		# this is essential for moving CharacterBodies
		move_and_collide(velocity * delta)
		
		# Required to start shooting the player
		Attack_timer += delta
		
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
			
		else:
			Ranged_sprite.play("Idle")
			velocity = Vector2.ZERO
	else:
		enemy_dead()


func _on_detection_area_body_entered(body: Node2D) -> void:
	# whatever enters the detection area is set to body
	# since only the player collides with this detection area, we set the body as the player
	Player = body
	# enemy will now chase the player
	Player_chase = true
	print("Enemy on sight")

func _on_detection_area_body_exited(body: Node2D) -> void:
	# we want to stop chasing the player once they exit
	Player = null
	Player_chase = false
	print("Bravo six going dark")

func shoot_projectile() -> void: 
	var Direction = (Player.position - position).normalized()
	
	var ProjectileInstance = Projectile.instantiate()
	ProjectileInstance.Direction = Direction.normalized()  
	ProjectileInstance.SpawnPos = global_position  # Use spawnPos like the player does
	ProjectileInstance.Fired_by = "Enemy"

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

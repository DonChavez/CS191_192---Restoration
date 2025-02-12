extends CharacterBody2D

@export var speed = 100
@export var lifetime = 2.0  
@export var max_bounces: int = 1
@export var can_pierce: bool = false  # If true, the projectile won't disappear on hit
@export var can_bounce: bool = false  # If true, allows bouncing

@onready var hurtbox = $HurtboxComponent 
@onready var sprite = $Sprite2D

var fired_by: String = "" 
var direction: Vector2 = Vector2.ZERO
var spawnPos: Vector2
var spawnRot: float
var bounce_count: int = 0

# Texture for projectiles
@export var player_projectile_texture: Texture2D
@export var enemy_projectile_texture: Texture2D

func _ready():
	global_position = spawnPos
	rotation = direction.angle()
	
	# Configure hurtbox and sprite based on who fired the projectile
	if fired_by == "player":
		hurtbox.set_collision_layer_value(5, true)		# Assign it as player projectile
		hurtbox.set_collision_mask_value(3, true)		# Can collide with enemies
		hurtbox.set_collision_mask_value(1, false)		# No collision with player
		sprite.texture = player_projectile_texture
		speed = 200									# More projecetile speed for player
	elif fired_by == "enemy":
		hurtbox.set_collision_layer_value(6, true)		# Assign it as penemy projectile
		hurtbox.set_collision_mask_value(1, true) 		# Can collide with player
		hurtbox.set_collision_mask_value(3, false)		# No collision with other enemies
		sprite.texture = enemy_projectile_texture
	
	# Connect hit detection to the _on_hit function
	if hurtbox:
		hurtbox.hit.connect(_on_hit)
	
	# Schedule the projectile to be destroyed after its time is over
	get_tree().create_timer(lifetime).timeout.connect(queue_free)

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(direction * speed * delta) 	# Move and check for collisions
	if collision:
		# If projectile can bounce, handle bouncing logic
		if can_bounce:
			if bounce_count >= max_bounces:
				queue_free()  
			else:
				bounce(collision.get_normal())	# Reflect direction based on collision normal
		else:
			queue_free()

# Bounce the projectile off a surface
func bounce(normal: Vector2):
	direction = direction.bounce(normal)  # Reflect the direction
	rotation = direction.angle()  # Adjust the rotation to match the new direction
	bounce_count += 1  # Increment bounce count

# Handle what happens when the projectile hits something
func _on_hit(_hitbox: HitboxComponent, _damage: float):
	# If piercing is not allowed, destroy the projectile after applying damage
	if not can_pierce:
		queue_free() 

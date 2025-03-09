extends CharacterBody2D

# exportables
@export var Speed = 100
@export var Lifetime = 2.0  
@export var MaxBounces = 0

# projectile textures
@export var Player_projectile_texture: Texture2D
@export var Enemy_projectile_texture: Texture2D

# onready variables
@onready var ProjectileHurtbox: HurtboxComponent = $ProjectileHurtbox
# sprite is changed depending on who fired it
@onready var ProjectileSprite: Sprite2D = $Sprite2D

# local variables
var Fired_by : String = "" # determines who fired the projectile
var Direction : Vector2 = Vector2.ZERO
var SpawnPos: Vector2
var bounce_count: int = 0  # Tracks the current number of bounces

func _ready() -> void:
	# set the spawn position of the projectile
	# do not touch
	global_position = SpawnPos
	reset_physics_interpolation()
	rotation = Direction.angle()
	
	fireblaster(Fired_by)

	# Schedule the projectile to be destroyed after its time is over
	get_tree().create_timer(Lifetime).timeout.connect(queue_free)

func fireblaster(Name: String) -> void:
	if Name == "Player":
		set_collision_layer_value(5, true)		# Make projectile body as player projectile
		ProjectileHurtbox.set_collision_layer_value(5, true)		# Assign it as player projectile
		ProjectileHurtbox.set_collision_layer_value(6, false)
		ProjectileHurtbox.set_collision_mask_value(3, true)			# Can collide with enemies
		ProjectileHurtbox.set_collision_mask_value(2, false)		# No collision with player
		ProjectileSprite.texture = Player_projectile_texture
		Speed = 200									# More projecetile speed for player
	if Name == "Enemy":
		set_collision_layer_value(6, true)		# Make projectile body as enemy projectile
		ProjectileHurtbox.set_collision_layer_value(5, false)
		ProjectileHurtbox.set_collision_layer_value(6, true)		# Assign it as enemy projectile
		ProjectileHurtbox.set_collision_mask_value(2, true) 		# Can collide with player
		ProjectileHurtbox.set_collision_mask_value(3, false)		# No collision with other enemies
		ProjectileSprite.texture = Enemy_projectile_texture
		
	
# Bounce the projectile off a surface
func bounce(Bounce_direction: Vector2) -> void:
	if bounce_count < MaxBounces:
		Direction = Direction.bounce(Bounce_direction).normalized()
		bounce_count += 1
	else:
		queue_free()  # Destroy projectile if max bounces exceeded
		
func redirect_to_nearest_enemy(collision_normal: Vector2) -> void:
	var nearest_enemy: Node2D = null
	var shortest_distance = INF
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		var distance = global_position.distance_to(enemy.global_position)
		if distance < shortest_distance:
			shortest_distance = distance
			nearest_enemy = enemy
	if nearest_enemy:
		Direction = (nearest_enemy.global_position - global_position).normalized()
		bounce_count += 1
	else:
		bounce(collision_normal)  # Perform a standard bounce if no enemies are found

func _physics_process(delta: float) -> void:
	var Collision = move_and_collide(Direction * Speed * delta) 	# Move and check for collisions
	if Collision:
		bounce(Collision.get_normal())
		

# handle what happens when the projectile hits something
func _on_projectile_hurtbox_hit(Hitbox: HitboxComponent, _amount: float) -> void:
	if Hitbox.is_in_group("TSHitbox"):
		var Normal = (global_position - Hitbox.global_position).normalized()
		redirect_to_nearest_enemy(Normal)  # Reflect the projectile
		
		Fired_by = "Player"
		fireblaster(Fired_by)
		
		return  # Do NOT queue_free()

	queue_free()  # Destroy if it hits anything else

	
	

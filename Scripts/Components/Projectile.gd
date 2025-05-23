extends CharacterBody2D

signal SUCCESSFUL_PARRY()

# exportables
@export var Speed = 100
@export var Lifetime = 2.0  
@export var MaxBounces = 0
@export var MaxPierce = 0

# projectile textures
@export var Player_projectile_texture: Texture2D
@export var Enemy_projectile_texture: Texture2D
@export var Boss_projectile_texture: Texture2D

# onready variables
@onready var ProjectileHurtbox: HurtboxComponent = $ProjectileHurtbox
# sprite is changed depending on who fired it
@onready var ProjectileSprite: Sprite2D = $Sprite2D

# local variables
var Fired_by : Node2D # determines who fired the projectile
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
	
	connect_to_player()
	# Schedule the projectile to be destroyed after its time is over
	get_tree().create_timer(Lifetime).timeout.connect(queue_free)

func fireblaster(Name: Node2D) -> void:
	#if Name == "Player":
	if Name and Name.is_in_group("Player"):
		set_collision_layer_value(5, true)		# Make projectile body as player projectile
		set_collision_mask_value(8, false)   # Added for parry sword
		ProjectileHurtbox.set_collision_layer_value(5, true)		# Assign it as player projectile
		ProjectileHurtbox.set_collision_layer_value(6, false)
		ProjectileHurtbox.set_collision_mask_value(3, true)			# Can collide with enemies
		ProjectileHurtbox.set_collision_mask_value(2, false)		# No collision with player
		ProjectileHurtbox.set_collision_mask_value(8, false)   # Can collide with hitbox
		ProjectileSprite.texture = Player_projectile_texture
		Speed = 200									# More projecetile speed for player
	if Name and Name.is_in_group("Enemy"):
		set_collision_layer_value(6, true)		# Make projectile body as enemy projectile
		set_collision_mask_value(8, true)   # Added for parry sword
		ProjectileHurtbox.set_collision_layer_value(5, false)
		ProjectileHurtbox.set_collision_layer_value(6, true)		# Assign it as enemy projectile
		ProjectileHurtbox.set_collision_mask_value(2, true) 		# Can collide with player
		ProjectileHurtbox.set_collision_mask_value(3, false)		# No collision with other enemies
		if Name and Name.is_in_group("Boss"):
			ProjectileSprite.texture = Boss_projectile_texture
		else:
			ProjectileSprite.texture = Enemy_projectile_texture
		
# Bounce the projectile off a surface with random direction
func bounce(bounce_normal: Vector2) -> void:
	if bounce_count < MaxBounces:
		# Check if the player is parrying
		if Fired_by != PlayerManager.Player_instance and PlayerManager.Player_instance.Is_parrying:
			# If player is parrying, redirect to the source instead of random bounce
			redirect_target()
		else:
			# Standard random bounce behavior
			# Generate a random angle between -45 and 45 degrees
			var random_angle = randf_range(-PI/4, PI/4)
			# First get the regular bounce direction
			var regular_bounce = Direction.bounce(bounce_normal).normalized()
			# Then rotate it by the random angle
			Direction = regular_bounce.rotated(random_angle)
			# Update the projectile's visual rotation
			rotation = Direction.angle()
		
		# Update bounce counter regardless of which path was taken
		bounce_count += 1
	else:
		queue_free()  # Destroy projectile if max bounces exceeded

# Redirect the projectile toward the entity that fired it
func redirect_target() -> void:
	# Only redirect if we have a valid source that fired the projectile
	if Fired_by and is_instance_valid(Fired_by):
		# Calculate direction toward the source that shot the projectile
		Direction = (Fired_by.global_position - global_position).normalized()
		# Update the projectile's visual rotation to match new direction
		rotation = Direction.angle()
		# Since we're now targeting the source, transfer ownership to player
		Fired_by = PlayerManager.Player_instance
		fireblaster(Fired_by)
	else:
		# If the source is no longer valid (e.g., enemy died), do a random redirect
		redirect_random()

# Redirect the projectile in a completely random direction
func redirect_random(collision_normal: Vector2 = Vector2.ZERO) -> void:
	# Generate a completely random direction
	var random_angle = randf_range(0, 2 * PI)  # Random angle between 0 and 2π
	Direction = Vector2(cos(random_angle), sin(random_angle))
	
	# Update the projectile's visual rotation
	rotation = Direction.angle()
	
	# Count this as a bounce
	bounce_count += 1

func _physics_process(delta: float) -> void:
	var Collision = move_and_collide(Direction * Speed * delta) 	# Move and check for collisions
	if Collision:
		bounce(Collision.get_normal())

# handle what happens when the projectile hits something
func _on_projectile_hurtbox_hit(Hitbox: HitboxComponent, _amount: float) -> void:
	if Hitbox.is_in_group("TSHitbox"):
		PlayerManager.play_block_sfx()
		var Normal = (global_position - Hitbox.global_position).normalized()
		#redirect_to_nearest_enemy(Normal)  # Reflect the projectile
		if PlayerManager.Player_instance.Is_parrying:
			redirect_target()
			SUCCESSFUL_PARRY.emit()
			#pass
		else:
			redirect_random()
		
		Fired_by = PlayerManager.Player_instance
		fireblaster(Fired_by)
		
		return  # Do NOT queue_free()
	if MaxPierce == 0:
		queue_free()  # Destroy if it hits anything else
	else:
		MaxPierce -=1


func connect_to_player():
	# Get all nodes in the "Player" group
	var Players = get_tree().get_nodes_in_group("Player")
	if Players.size() > 0:
		# Connect to the first Player (assuming one Player)
		var Player = Players[0]
		# Connect to the first Player (assuming one Player)
		connect("SUCCESSFUL_PARRY", Callable(Player, "on_projectile_parry"))
	else:
		print("Warning: No Player found in group 'Player'")


# Handles Increasing Live time
func add_live_time(Added_time: int):
	Lifetime += Added_time
	
# Handles adding Pierce
func add_pierce_count(Added_pierce: int):
	MaxPierce += Added_pierce

func implement_damage(New_damage: float) -> void:
	ProjectileHurtbox.hurtbox_implement_damage(New_damage)

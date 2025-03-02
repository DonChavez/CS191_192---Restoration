extends CharacterBody2D

# exportables
@export var Speed = 100
@export var Lifetime = 2.0  

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

func _ready() -> void:
	# set the spawn position of the projectile
	global_position = SpawnPos
	rotation = Direction.angle()

	if Fired_by == "Player":
		ProjectileHurtbox.set_collision_layer_value(5, true)		# Assign it as player projectile
		ProjectileHurtbox.set_collision_mask_value(3, true)			# Can collide with enemies
		ProjectileHurtbox.set_collision_mask_value(2, false)		# No collision with player
		ProjectileSprite.texture = Player_projectile_texture
		Speed = 200									# More projecetile speed for player
	if Fired_by == "Enemy":
		ProjectileHurtbox.set_collision_layer_value(6, true)		# Assign it as enemy projectile
		ProjectileHurtbox.set_collision_mask_value(2, true) 		# Can collide with player
		ProjectileHurtbox.set_collision_mask_value(3, false)		# No collision with other enemies
		ProjectileSprite.texture = Enemy_projectile_texture
		
	# Connect hit detection to the _on_hit function
	if ProjectileHurtbox:
		ProjectileHurtbox.hit.connect(_on_hit)
		
	# Schedule the projectile to be destroyed after its time is over
	get_tree().create_timer(Lifetime).timeout.connect(queue_free)

func _physics_process(delta: float) -> void:
	var Collision = move_and_collide(Direction * Speed * delta) 	# Move and check for collisions
	if Collision:
		queue_free()

# Handle what happens when the projectile hits something
func _on_hit(_hitbox: HitboxComponent, _damage: float):
	queue_free() 

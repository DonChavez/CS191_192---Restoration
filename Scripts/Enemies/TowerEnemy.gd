extends CharacterBody2D

# onready variables
@onready var Tower_sprite: Sprite2D = $TowerEnemySprite

@onready var Tower_health: HealthComponent = $TowerEnemyHealth
@onready var Tower_hitbox: HitboxComponent = $TowerEnemyHitbox

# exportable variables
@export var Projectile = load("res://Scenes/Objects/Projectile.tscn")

# Attack variables
@export var Attack_timer: float = 0.0  # Tracks time since last attack
@export var Attack_cooldown: float = 1.0  # Delay between attacks
@export var Rotation_offset: float = 0.0  # Rotation angle for projectile pattern
@export var Rotation_speed: float = 30.0  # Degrees per second to rotate the pattern

# movemovent variables
var Speed = 50

# player variables
var Player = null

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if !is_dead():
		# Required to start shooting the player
		Attack_timer += delta
		
		velocity = Vector2.ZERO
		
		# shoot the player
		if Attack_timer >= Attack_cooldown:
			circle_attack()
			Attack_timer = 0.0
		
		# Rotate the pattern over time
		Rotation_offset += Rotation_speed * delta
		Rotation_offset = fmod(Rotation_offset, 360.0)  # Keep within 0-360 degrees
			
		
	else:
		enemy_dead()

# these will be used for updating the tower eventually
func _on_detection_area_body_entered(body: Node2D) -> void:
	# whatever enters the detection area is set to body
	# since only the player collides with this detection area, we set the body as the player
	Player = body
	# enemy will now chase the player
	print("The EYE Sees YOU")

func _on_detection_area_body_exited(_body: Node2D) -> void:
	# we want to stop chasing the player once they exit
	Player = null
	print("GIVE ME BACK MY RING")

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
		ProjectileInstance.Fired_by = "Enemy"

		get_parent().add_child.call_deferred(ProjectileInstance)  # Ensure it spawns properly

func is_dead() -> bool: 
	return Tower_health.Health <= 0

func enemy_dead() -> void:
	print("NOOOOOOOOOOOOOOOOOOOOO")
	queue_free()

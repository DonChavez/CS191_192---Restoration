extends Area2D

@export var lifetime: float = 2.0  # Duration of the shield
@onready var collision_shape = $CollisionShape2D  # Get collision shape from the scene
@onready var sprite = $Sprite2D

func _ready():
	# Disable the shield instead of freeing it
	disable_shield()
		
# Function to enable the shield
func enable_shield():
	visible = true
	set_deferred("monitoring", true)  # Enable collision safely
	
	sprite.modulate = Color(1, 1, 1, 1)

	# Disable shield after `lifetime` seconds
	await get_tree().create_timer(lifetime).timeout
	disable_shield()

# Function to disable the shield
func disable_shield():
	visible = false
	set_deferred("monitoring", false)  # Disable collision safely
	
	sprite.modulate = Color(1, 1, 1, 0.5)

extends Camera2D

@onready var Player: CharacterBody2D = $".."
@export var Follow_speed: float = 10.0 	# Speed of catch-up
@export var Max_distance: float = 300.0 # Max lag distance
var Is_dashing: bool = false 			# Track dash state
var Target_offset: Vector2 = Vector2.ZERO # Local offset to interpolate

func _ready() -> void:
	position_smoothing_enabled = false

func on_player_dashed(Pre_dash_position: Vector2) -> void:
	# Calculate local offset to keep camera at pre-dash global position
	var Post_dash_position = Player.global_position
	var offset = Pre_dash_position - Post_dash_position
	Target_offset = offset
	position = Target_offset
	Is_dashing = true

func _physics_process(Delta: float) -> void:
	
	if Is_dashing:
		# Interpolate local position toward (0,0) to catch up
		var Distance = position.distance_to(Vector2.ZERO)
		var Dynamic_speed = Follow_speed * clamp(Distance / Max_distance, 0.5, 3.0)
		
		position = position.lerp(Vector2.ZERO, Dynamic_speed * Delta)
		
		# Stop dashing when close enough
		if Distance < 1.0:
			Is_dashing = false
			position = Vector2.ZERO
		

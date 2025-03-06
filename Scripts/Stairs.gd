extends Area2D

@export var slow_factor: float = 0.5  # Reduces speed to 50%
@export var player: Node  # Assign the player node in the editor

var original_speed: float

func _on_body_entered(body):
	if body.is_in_group("Player"):
		print("Player entered")
		original_speed = body.Move_speed  # Store original speed
		body.Move_speed *= slow_factor  # Apply slow effect

func _on_body_exited(body):
	if body.is_in_group("Player"):
		body.Move_speed = original_speed  # Restore speed

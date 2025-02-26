extends CharacterBody2D

var speed = 40
var dash_speed = 200
var player_chase = false
var player = null
var dash_direction = Vector2.ZERO

@export var projectile = load("res://Scenes/Templates/Projectile.tscn")  # Load projectile scene directly

func _physics_process(delta):
	if player_chase and player:
		var direction = (player.position - position).normalized()
		velocity = direction * speed

		var collision = move_and_collide(velocity * delta)
		if collision:
			velocity = Vector2.ZERO

func _on_area_2d_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true

func _on_area_2d_body_exited(_body: Node2D) -> void:
	player = null
	player_chase = false
		
func _on_health_component_died() -> void:
	queue_free()

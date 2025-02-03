extends CharacterBody2D

var speed = 25
var player_chase = false
var player = null

func _physics_process(_delta):
	if player_chase:
		var direction = (player.position - position).normalized()
		
		velocity = direction * speed
		
		$AnimatedSprite2D.play("walk")
		
		var collision = move_and_collide(velocity * _delta)
		
		if collision and collision.get_collider().is_in_group("player"):
			$AnimatedSprite2D.play("idle")
			velocity = Vector2.ZERO
		else:
			$AnimatedSprite2D.play("walk")

		$AnimatedSprite2D.flip_h = player.position.x < position.x
		
	else:
		$AnimatedSprite2D.play("idle")
		velocity = Vector2.ZERO
		
func _on_area_2d_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true

func _on_area_2d_body_exited(_body: Node2D) -> void:
	player = null
	player_chase = false

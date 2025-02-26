extends CharacterBody2D

var speed = 25
var dash_speed = 200
var player_chase = false
var player = null
var dashing = false
var dash_direction = Vector2.ZERO

@export var projectile = load("res://Scenes/Templates/Projectile.tscn")  # Load projectile scene directly

@onready var dash_timer = $DashTimer

func _ready():
	dash_timer.wait_time = 1  
	dash_timer.one_shot = false
	dash_timer.timeout.connect(_on_dash_timer_timeout)
	dash_timer.start()

func _physics_process(delta):
	if dashing:
		velocity = dash_direction * dash_speed
		move_and_collide(velocity * delta)
		return

	if player_chase and player:
		var direction = (player.position - position).normalized()
		velocity = direction * speed
		$AnimatedSprite2D.play("walk")

		var collision = move_and_collide(velocity * delta)
		if collision and collision.get_collider().is_in_group("player"):
			$AnimatedSprite2D.play("idle")
			velocity = Vector2.ZERO

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
	dashing = false

func _on_dash_timer_timeout():
	if player_chase and player:

		# Optional: Enemy dashes after shooting
		dash_direction = (player.position - position).normalized()
		dashing = true
		await get_tree().create_timer(0.3).timeout
		dashing = false
		
func circle_attack():
	var num_projectiles = 8
	var angle_step = TAU / num_projectiles  

	for i in range(num_projectiles):
		var angle = i * angle_step
		var direction = Vector2(cos(angle), sin(angle))

		var instance = projectile.instantiate()
		instance.direction = direction.normalized()  
		instance.spawnPos = global_position  # Use spawnPos like the player does
		instance.fired_by = "enemy"

		get_parent().add_child.call_deferred(instance)  # Ensure it spawns properly

func _on_health_component_died() -> void:
	queue_free()

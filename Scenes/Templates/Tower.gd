extends CharacterBody2D

var speed = 25
var dash_speed = 200
var player_chase = false
var player = null
var dashing = false
var dash_direction = Vector2.ZERO

@export var projectile = load("res://Scenes/Templates/Projectile.tscn")  # Load projectile scene directly

var attack_timer: Timer  # Timer for shooting

func _ready():
	# Create and configure attack timer
	attack_timer = Timer.new()
	attack_timer.wait_time = 0.7  # Adjust attack interval as needed
	attack_timer.autostart = false
	attack_timer.one_shot = false
	attack_timer.timeout.connect(_on_attack_timer_timeout)
	add_child(attack_timer)

func _physics_process(delta):
	if dashing:
		velocity = dash_direction * dash_speed
		move_and_slide()

func shoot_projectile():
	var instance = projectile.instantiate()
	var direction = (player.position - position).normalized()
	instance.direction = direction
	instance.spawnPos = global_position 
	instance.fired_by = "enemy"
	add_child.call_deferred(instance)

func _on_attack_timer_timeout():
	if player_chase and player:
		shoot_projectile()

func _on_area_2d_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true
	attack_timer.start()  # Start attack timer when player enters range

func _on_area_2d_body_exited(_body: Node2D) -> void:
	player = null
	player_chase = false
	attack_timer.stop()  # Stop attacking when player leaves range

func _on_dash_timer_timeout():
	if player_chase and player:
		dash_direction = (player.position - position).normalized()
		dashing = true
		await get_tree().create_timer(0.3).timeout
		dashing = false	

func _on_health_component_died() -> void:
	queue_free()

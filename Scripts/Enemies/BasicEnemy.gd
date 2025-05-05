extends CharacterBody2D

# onready variables
@onready var BE_sprite: AnimatedSprite2D = $BasicEnemySprite
@onready var BE_health: HealthComponent = $BasicEnemyHealth
@onready var BE_hitbox: HitboxComponent = $BasicEnemyHitbox
@onready var Line_of_sight: RayCast2D = $EnemyLOS
@onready var Wait_timer: Timer = $WaitTimer
@onready var Coin_spawner: Node = $CoinSpawner

# movement variables
var Speed = 50
var Last_direction : Vector2 = Vector2.ZERO
var Is_waiting : bool = false

# player variables
var Player_chase = false
var Player = null

func _ready() -> void:
	# default animation start
	BE_sprite.play("Idle")
	Line_of_sight.enabled = true
	Wait_timer.timeout.connect(_on_wait_timer_timeout)

func _physics_process(delta: float) -> void:
	if !is_dead():
		if Player != null and !Is_waiting:
			Line_of_sight.target_position = Player.global_position - global_position
			Line_of_sight.force_raycast_update()
			if Line_of_sight.is_colliding() and Line_of_sight.get_collider() == Player:
				Player_chase = true
				Last_direction = (Player.position - position).normalized()
			else:
				Player_chase = false
		
		if Player_chase:
			var Direction = (Player.position - position).normalized()
			velocity = Direction * Speed
			BE_sprite.play("Move")
			BE_sprite.flip_h = Player.position.x < position.x
		elif Is_waiting:
			velocity = Last_direction * Speed
			BE_sprite.play("Move")
			BE_sprite.flip_h = Last_direction.x < 0
		else:
			velocity = Vector2.ZERO
			BE_sprite.play("Idle")
		
		move_and_slide()
	else:
		enemy_dead()

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Player = body
		if Is_waiting:
			Is_waiting = false
			Wait_timer.stop()

func _on_detection_area_body_exited(_body: Node2D) -> void:
	if _body == Player and Player_chase:
		Is_waiting = true
		Player_chase = false
		Wait_timer.start()

func _on_wait_timer_timeout() -> void:
	if Is_waiting:
		Is_waiting = false
		Player = null
		print("Wait a minute... who are you?")

func is_dead() -> bool:
	return BE_health.Health <= 0

func enemy_dead() -> void:
	BE_sprite.play("Death")
	BE_hitbox.monitoring = false
	
	var Death_animation_name : String = "Death"
	var Death_animation_speed : float = BE_sprite.get_sprite_frames().get_animation_speed(Death_animation_name)
	var Death_animation_frames : float = BE_sprite.get_sprite_frames().get_frame_count(Death_animation_name)
	var Death_animation_length : float = (Death_animation_frames / Death_animation_speed)
	var Death_frame_speed : float = Death_animation_length / Death_animation_frames
	
	Coin_spawner.spawn_coin(2)
	
	await get_tree().create_timer(Death_animation_length - Death_frame_speed, false, true).timeout
	queue_free()

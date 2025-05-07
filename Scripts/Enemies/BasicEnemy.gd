extends CharacterBody2D

# onready variables
@onready var BE_sprite: AnimatedSprite2D = $BasicEnemySprite
@onready var BE_health: HealthComponent = $BasicEnemyHealth
@onready var BE_hitbox: HitboxComponent = $BasicEnemyHitbox
@onready var BE_hurtbox: HurtboxComponent = $BasicEnemyHurtbox
@onready var Line_of_sight: RayCast2D = $EnemyLOS
@onready var Wait_timer: Timer = $WaitTimer
@onready var Coin_spawner: Node = $CoinSpawner

var knockback_velocity: Vector2 = Vector2.ZERO
@export var knockback_decay_rate: float = 6.0
@export var Knockback_strength : float = 100.0

# movement variablesa
var Speed = 50
var Last_direction : Vector2 = Vector2.ZERO
var Is_waiting : bool = false
var Is_dying : bool = false

# player variables
var Player_chase = false
var Player = null

# patrol variables
var Spawn_position : Vector2
var Patrol_distance : float = 50.0
var Patrol_direction : Vector2 = Vector2.RIGHT
var Walk_time : float = Patrol_distance / Speed  # Time to walk in one direction

# patrol state variables
enum PatrolState { WALKING, IDLING }
var Current_patrol_state = PatrolState.WALKING
var Idle_timer: Timer
var Idle_time: float = 1.0  # Time to idle before walking again
var Walk_timer: Timer

# New variables for post-chase idle
var Is_idling_after_chase : bool = false
var Post_chase_idle_timer : Timer

func _ready() -> void:
	# default animation start
	BE_sprite.play("Idle")
	Line_of_sight.enabled = true
	Wait_timer.timeout.connect(_on_wait_timer_timeout)
	
	# Initialize patrol variables
	Spawn_position = position
	
	# Create idle timer
	Idle_timer = Timer.new()
	Idle_timer.one_shot = true
	Idle_timer.wait_time = Idle_time
	add_child(Idle_timer)
	Idle_timer.timeout.connect(_on_idle_timer_timeout)
	
	# Create walk timer
	Walk_timer = Timer.new()
	Walk_timer.one_shot = true
	Walk_timer.wait_time = Walk_time
	add_child(Walk_timer)
	Walk_timer.timeout.connect(_on_walk_timer_timeout)
	
	# Create post-chase idle timer
	Post_chase_idle_timer = Timer.new()
	Post_chase_idle_timer.one_shot = true
	Post_chase_idle_timer.wait_time = 2.0
	add_child(Post_chase_idle_timer)
	Post_chase_idle_timer.timeout.connect(_on_post_chase_idle_timer_timeout)
	
	# Start walking initially
	var pause_duration = randf_range(1.0, 3.0)
	await get_tree().create_timer(pause_duration).timeout
	Walk_timer.start()

func _physics_process(delta: float) -> void:
	if !is_dead():
		if knockback_velocity.length() > 1.0:
			position += knockback_velocity * delta
			# Exponential decay
			knockback_velocity *= exp(-knockback_decay_rate * delta)
		else:
			knockback_velocity = Vector2.ZERO
			
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
		elif Is_idling_after_chase:
			velocity = Vector2.ZERO
			BE_sprite.play("Idle")
		else:
			# Patrol behavior
			match Current_patrol_state:
				PatrolState.WALKING:
					velocity = Speed * Patrol_direction
					BE_sprite.play("Move")
					BE_sprite.flip_h = Patrol_direction.x < 0
				PatrolState.IDLING:
					velocity = Vector2.ZERO
					BE_sprite.play("Idle")
		
		move_and_collide(velocity * delta)
	else:
		if !Is_dying:
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
	BE_hurtbox.monitoring = false
	Is_dying = true
	ProgressionManager.add_slime_defeated()
	
	var Death_animation_name : String = "Death"
	var Death_animation_speed : float = BE_sprite.get_sprite_frames().get_animation_speed(Death_animation_name)
	var Death_animation_frames : float = BE_sprite.get_sprite_frames().get_frame_count(Death_animation_name)
	var Death_animation_length : float = (Death_animation_frames / Death_animation_speed)
	var Death_frame_speed : float = Death_animation_length / Death_animation_frames
	
	Coin_spawner.spawn_coin(2)
	
	await get_tree().create_timer(Death_animation_length - Death_frame_speed, false, true).timeout
	queue_free()

func apply_knockback(force: Vector2) -> void:
	knockback_velocity = force

func _on_basic_enemy_hurtbox_hit(player_hitbox: HitboxComponent, amount: float) -> void:
	var player = player_hitbox.get_parent()
	if player and player.has_method("apply_knockback"):
		var dir = (player.global_position - global_position).normalized()
		player.apply_knockback(dir * Knockback_strength)
		print("knockback")


func _on_walk_timer_timeout() -> void:
	if Current_patrol_state == PatrolState.WALKING and not Player_chase and not Is_waiting and not Is_idling_after_chase:
		Current_patrol_state = PatrolState.IDLING
		Idle_timer.start()

func _on_idle_timer_timeout() -> void:
	if Current_patrol_state == PatrolState.IDLING and not Player_chase and not Is_waiting and not Is_idling_after_chase:
		Current_patrol_state = PatrolState.WALKING
		Patrol_direction = -Patrol_direction
		Walk_timer.start()

func _on_post_chase_idle_timer_timeout() -> void:
	Is_idling_after_chase = false
	Current_patrol_state = PatrolState.WALKING
	Patrol_direction = Vector2.RIGHT  # Start walking right after idle
	Walk_timer.start()

extends CharacterBody2D

# onready variables
@onready var Ranged_sprite: AnimatedSprite2D = $RangedEnemySprite
@onready var Ranged_health: HealthComponent = $RangedEnemyHealth
@onready var Ranged_hitbox: HitboxComponent = $RangedEnemyHitbox
@onready var Ranged_los: RayCast2D = $RangedLOS
@onready var Wait_timer: Timer = $WaitTimer
@onready var Coin_spawner: Node = $CoinSpawner

# exportable variables
@export var Projectile = load("res://Scenes/Objects/Projectile.tscn")

# Attack variables
@export var Attack_timer: float = 0.0
@export var Attack_cooldown: float = 1.0
var is_attacking: bool = false
var knockback_velocity: Vector2 = Vector2.ZERO
@export var knockback_decay_rate: float = 6.0
@export var Knockback_strength : float = 100.0

# movement variables
var Speed = 50
var Last_direction : Vector2 = Vector2.ZERO
var Is_waiting : bool = false
var Run_away : bool = false
var Is_dying : bool = false

# player variables
var Player_chase = false
var Player = null

# music variables
@onready var Ranged_sfx: AudioStreamPlayer2D = $AudioStreamPlayer2D

# Patrol variables
var Spawn_position : Vector2
var Patrol_distance : float = 50.0
var Patrol_direction : Vector2 = Vector2.RIGHT
var Walk_time : float = Patrol_distance / Speed
enum PatrolState { WALKING, IDLING }
var Current_patrol_state = PatrolState.WALKING
var Idle_timer: Timer
var Idle_time: float = 1.0
var Walk_timer: Timer

# Post-chase idle variables
var Is_idling_after_chase : bool = false
var Post_chase_idle_timer : Timer

func _ready() -> void:
	Ranged_sprite.play("Idle")
	Ranged_los.enabled = true
	Wait_timer.timeout.connect(_on_wait_timer_timeout)
	Ranged_sprite.animation_finished.connect(_on_animation_finished)
	
	# Initialize patrol variables
	Spawn_position = position
	Idle_timer = Timer.new()
	Idle_timer.one_shot = true
	Idle_timer.wait_time = Idle_time
	add_child(Idle_timer)
	Idle_timer.timeout.connect(_on_idle_timer_timeout)
	
	Walk_timer = Timer.new()
	Walk_timer.one_shot = true
	Walk_timer.wait_time = Walk_time
	add_child(Walk_timer)
	Walk_timer.timeout.connect(_on_walk_timer_timeout)
	
	Post_chase_idle_timer = Timer.new()
	Post_chase_idle_timer.one_shot = true
	Post_chase_idle_timer.wait_time = 2.0
	add_child(Post_chase_idle_timer)
	Post_chase_idle_timer.timeout.connect(_on_post_chase_idle_timer_timeout)
	
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
		move_and_collide(velocity * delta)
		
		Attack_timer += delta
		
		if Player != null and !Is_waiting and !Run_away:
			Ranged_los.target_position = Player.global_position - global_position
			Ranged_los.force_raycast_update()
			if Ranged_los.is_colliding() and Ranged_los.get_collider() == Player:
				Player_chase = true
				Last_direction = (Player.position - position).normalized()
			else:
				Player_chase = false
		
		if Player_chase:
			#var Direction = (Player.position - position).normalized()
			#velocity = Direction * Speed
			
			# Play appropriate animation based on attack state
			if is_attacking:
				velocity = Vector2.ZERO
				Ranged_sprite.play("Attack")
			else:
				#velocity = Direction * Speed
				Ranged_sprite.play("Move")
				
			if Attack_timer >= Attack_cooldown and !is_attacking:
				start_attack()
			
			Ranged_sprite.flip_h = Player.position.x < position.x
		
		elif Run_away:
			is_attacking = false
			var Direction = (position - Player.position).normalized()
			velocity = Direction * Speed
			
			Ranged_sprite.flip_h = Player.position.x > position.x
		
		elif Is_waiting:
			velocity = Last_direction * Speed
			Ranged_sprite.play("Move")
		
		else:
			match Current_patrol_state:
				PatrolState.WALKING:
					velocity = Speed * Patrol_direction
					Ranged_sprite.play("Move")
					Ranged_sprite.flip_h = Patrol_direction.x < 0
				PatrolState.IDLING:
					velocity = Vector2.ZERO
					Ranged_sprite.play("Idle")
	else:
		if !Is_dying:
			enemy_dead()

func start_attack() -> void:
	if !Run_away:
		is_attacking = true
		Attack_timer = 0.0
		Ranged_sprite.play("Attack")
		
		# Calculate time for 4th frame (assuming 0-based index)
		var attack_speed = Ranged_sprite.get_sprite_frames().get_animation_speed("Attack")
		var frame_duration = 1.0 / attack_speed
		var time_to_frame_4 = frame_duration * 2 
		
		# Wait until 4th frame to spawn projectile
		await get_tree().create_timer(time_to_frame_4).timeout
		shoot_projectile()

func _on_animation_finished() -> void:
	if Ranged_sprite.animation == "Attack":
		is_attacking = false

func shoot_projectile() -> void: 
	var Direction = (Player.position - position).normalized()
	
	var ProjectileInstance = Projectile.instantiate()
	ProjectileInstance.Direction = Direction.normalized()
	ProjectileInstance.SpawnPos = global_position
	ProjectileInstance.Fired_by = self
	Ranged_sfx.play()

	get_parent().add_child.call_deferred(ProjectileInstance)

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Player = body
		if Is_waiting:
			Is_waiting = false
			Wait_timer.stop()

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body == Player and Player_chase:
		Is_waiting = true
		Player_chase = false
		Wait_timer.start()

func _on_get_away_from_me_body_entered(body: Node2D) -> void:
	if body == Player and Player_chase:
		Player_chase = false
		Run_away = true
		print("GET AWAY FROM ME")

func _on_get_away_from_me_body_exited(body: Node2D) -> void:
	if body == Player:
		Player_chase = true
		Run_away = false
		print("COME BACK HERE")

func _on_wait_timer_timeout() -> void:
	if Is_waiting:
		Is_waiting = false
		Is_idling_after_chase = true
		Post_chase_idle_timer.start()
		Player = null
		Spawn_position = position
		print("Wait a minute... who are you?")

func _on_walk_timer_timeout() -> void:
	if Current_patrol_state == PatrolState.WALKING and not Player_chase and not Is_waiting and not Is_idling_after_chase and not Run_away:
		Current_patrol_state = PatrolState.IDLING
		Idle_timer.start()

func _on_idle_timer_timeout() -> void:
	if Current_patrol_state == PatrolState.IDLING and not Player_chase and not Is_waiting and not Is_idling_after_chase and not Run_away:
		Current_patrol_state = PatrolState.WALKING
		Patrol_direction = -Patrol_direction
		Walk_timer.start()

func _on_post_chase_idle_timer_timeout() -> void:
	Is_idling_after_chase = false
	Current_patrol_state = PatrolState.WALKING
	Patrol_direction = Vector2.RIGHT
	Walk_timer.start()


func is_dead() -> bool: 
	return Ranged_health.Health <= 0

func enemy_dead() -> void:
	Is_dying = true
	Ranged_sprite.play("Death")
	Ranged_hitbox.monitoring = false
	
	var Death_animation_name : String = "Death"
	var Death_animation_speed : float = Ranged_sprite.get_sprite_frames().get_animation_speed(Death_animation_name)
	var Death_animation_frames : float = Ranged_sprite.get_sprite_frames().get_frame_count(Death_animation_name)
	var Death_animation_length : float = (Death_animation_frames / Death_animation_speed)
	var Death_frame_speed : float = Death_animation_length / Death_animation_frames
	
	await get_tree().create_timer(Death_animation_length - Death_frame_speed, false, true).timeout
	
	Coin_spawner.spawn_coin(10)
	
	queue_free()

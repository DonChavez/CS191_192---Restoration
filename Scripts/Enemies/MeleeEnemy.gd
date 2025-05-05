extends CharacterBody2D

# onready variables
@onready var Melee_sprite: AnimatedSprite2D = $MeleeEnemySprite
@onready var Melee_health: HealthComponent = $MeleeEnemyHealth
@onready var Melee_hitbox: HitboxComponent = $MeleeEnemyHitbox
@onready var DashTimer: Timer = $DashTimer
@onready var Melee_los: RayCast2D = $MeleeLOS
@onready var Wait_timer: Timer = $WaitTimer
@onready var Melee_sfx: AudioStreamPlayer2D = $MeleeSFX
@onready var Coin_spawner: Node = $CoinSpawner
@onready var Melee_attack: HurtboxComponent = $MeleeAttack
@onready var Melee_melee_detection_area: Area2D = $MeleeDetectionArea

# exportable variables
@export var Speed = 50
@export var Dash_speed = 200
@export var Dash_cooldown : float = 2.0
@export var Dash_duration : float = 0.3

# melee variables
@export var Melee_cooldown: float = 1.5
var melee_timer: float = 0.0
var is_melee_attacking: bool = false
var Player_in_melee_range: bool = false

# local variables
var Last_direction : Vector2 = Vector2.ZERO
var Is_waiting : bool = false
var Dashing = false
var Dash_direction = Vector2.ZERO
var Player_chase = false
var Player = null

# Animation state tracking
var current_animation: String = "Idle"

func _ready() -> void:
	Melee_sprite.play("Idle")
	current_animation = "Idle"
	Melee_los.enabled = true
	
	DashTimer.wait_time = 1
	DashTimer.one_shot = false
	DashTimer.timeout.connect(_on_dash_timer_timeout)
	DashTimer.start()
	Wait_timer.timeout.connect(_on_wait_timer_timeout)
	
	# Initialize melee attack area as invisible and non-functional
	Melee_attack.monitoring = false
	Melee_attack.monitorable = false
	Melee_attack.visible = false
	
	Melee_sprite.animation_finished.connect(_on_animation_finished)

func _physics_process(delta: float) -> void:
	if !is_dead():
		if Dashing:
			velocity = Dash_direction * Dash_speed
			move_and_collide(velocity * delta)
			return
		
		move_and_collide(velocity * delta)
		
		melee_timer += delta
		
		if Player != null and !Is_waiting:
			Melee_los.target_position = Player.global_position - global_position
			Melee_los.force_raycast_update()
			if Melee_los.is_colliding() and Melee_los.get_collider() == Player:
				Player_chase = true
				Last_direction = (Player.position - position).normalized()
			else:
				Player_chase = false
		
		# Update velocity and state
		if Player_chase and Player:
			var Direction = (Player.position - position).normalized()
			velocity = Direction * Speed
			
			# Attack logic: Melee if in range
			if Player_in_melee_range and !is_melee_attacking:
				start_melee_attack()
			
			Melee_sprite.flip_h = Player.position.x < position.x
		
		elif Is_waiting:
			velocity = Last_direction * Speed
			Melee_sprite.flip_h = Last_direction.x < 0
		else:
			velocity = Vector2.ZERO
		
		update_animation()
	else:
		enemy_dead()

func update_animation() -> void:
	var new_animation = "Idle"
	
	if is_melee_attacking:
		new_animation = "Attack"
	elif velocity != Vector2.ZERO:
		new_animation = "Move"
	else:
		new_animation = "Idle"
	
	if new_animation != current_animation:
		Melee_sprite.play(new_animation)
		current_animation = new_animation

func start_melee_attack() -> void:
	is_melee_attacking = true
	melee_timer = 0.0
	
	if Melee_sfx:
		if Melee_sfx.playing:
			Melee_sfx.stop()
		Melee_sfx.play()
	
	var attack_speed = Melee_sprite.get_sprite_frames().get_animation_speed("Attack")
	var frame_duration = 1.0 / attack_speed
	var attack_length = frame_duration * Melee_sprite.get_sprite_frames().get_frame_count("Attack")
	
	# Play animation
	Melee_sprite.play("Attack")
	
	# Wait for 30% of animation time before activating melee attack area
	await get_tree().create_timer(attack_length * 0.3).timeout
	
	# Activate melee attack area
	Melee_attack.monitoring = true
	Melee_attack.monitorable = true
	Melee_attack.visible = true
	
	# Keep active for 40% of animation time
	await get_tree().create_timer(attack_length * 0.4).timeout
	
	# Deactivate melee attack area
	Melee_attack.monitoring = false
	Melee_attack.monitorable = false
	Melee_attack.visible = false
	
	# Wait for remaining 30% of animation time
	await get_tree().create_timer(attack_length * 0.3).timeout
	
	# Add random delay of 1-3 seconds before allowing another melee attack
	var random_delay = 1.0 + randf() * 2.0
	await get_tree().create_timer(random_delay).timeout
	
	is_melee_attacking = false

func _on_animation_finished() -> void:
	if Melee_sprite.animation == "Attack":
		pass  # Handled in start_melee_attack
	update_animation()

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Player = body
		print("URRARRUU!")
		if Is_waiting:
			Is_waiting = false
			Wait_timer.stop()
		DashTimer.start()

func _on_detection_area_body_exited(_body: Node2D) -> void:
	if _body == Player and Player_chase:
		Is_waiting = true
		Player_chase = false
		Wait_timer.start()
		Dashing = false
		DashTimer.stop()
		print("Where did you go?")

func _on_dash_timer_timeout() -> void:
	if Player_chase and Player:
		Dash_direction = (Player.position - position).normalized()
		Dashing = true
		await get_tree().create_timer(Dash_duration).timeout
		Dashing = false
		DashTimer.start(Dash_cooldown)

func _on_wait_timer_timeout() -> void:
	if Is_waiting:
		Is_waiting = false
		Player = null
		print("Que?")

func is_dead() -> bool:
	return Melee_health.Health <= 0

func enemy_dead() -> void:
	if current_animation != "Death":
		Melee_sprite.play("Death")
		current_animation = "Death"
		Melee_hitbox.monitoring = false
	
	var Death_animation_name : String = "Death"
	var Death_animation_speed : float = Melee_sprite.get_sprite_frames().get_animation_speed(Death_animation_name)
	var Death_animation_frames : float = Melee_sprite.get_sprite_frames().get_frame_count(Death_animation_name)
	var Death_animation_length : float = (Death_animation_frames / Death_animation_speed)
	
	Coin_spawner.spawn_coin(5)
	
	await get_tree().create_timer(Death_animation_length).timeout
	queue_free()

func _on_melee_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Player_in_melee_range = true
		print("I'll get you")

func _on_melee_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Player_in_melee_range = false
		print("Get back here!")

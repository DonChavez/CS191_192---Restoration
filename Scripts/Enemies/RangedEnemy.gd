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

# movement variables
var Speed = 50
var Last_direction : Vector2 = Vector2.ZERO
var Is_waiting : bool = false
var Run_away : bool = false

# player variables
var Player_chase = false
var Player = null

# music variables
@onready var Ranged_sfx: AudioStreamPlayer2D = $AudioStreamPlayer2D


func _ready() -> void:
	Ranged_sprite.play("Idle")
	Ranged_los.enabled = true
	Wait_timer.timeout.connect(_on_wait_timer_timeout)
	Ranged_sprite.animation_finished.connect(_on_animation_finished)

func _physics_process(delta: float) -> void:
	if !is_dead():
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
			Ranged_sprite.play("Idle")
			velocity = Vector2.ZERO
	else:
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
		Player = null

func is_dead() -> bool: 
	return Ranged_health.Health <= 0

func enemy_dead() -> void:
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

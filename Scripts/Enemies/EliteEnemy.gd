extends CharacterBody2D

# onready variables
@onready var Elite_sprite: AnimatedSprite2D = $EliteEnemySprite
@onready var Elite_health: HealthComponent = $EliteEnemyHealth
@onready var Elite_hitbox: HitboxComponent = $EliteEnemyHitbox
@onready var DashTimer: Timer = $DashTimer
@onready var Elite_los: RayCast2D = $EliteLOS
@onready var Wait_timer: Timer = $WaitTimer

# exportable variables
# movement variables
@export var Speed = 50
@export var Dash_speed = 200
@export var Dash_cooldown : float = 2.0
@export var Dash_duration : float = 0.3
var Last_direction : Vector2 = Vector2.ZERO
var Is_waiting : bool = false

# shooting variables
@export var Projectile = load("res://Scenes/Objects/Projectile.tscn")
@export var Shoot_timer: float = 0.0
@export var Shoot_cooldown: float = 1.0
@export var Rotation_offset: float = 0.0
@export var Rotation_speed: float = 30.0
var is_ranged_attacking: bool = false

# melee variables
@export var Melee_range: float = 50.0
@export var Melee_cooldown: float = 1.5
var melee_timer: float = 0.0
var is_melee_attacking: bool = false

# local variables
var Dashing = false
var Dash_direction = Vector2.ZERO

# player variables
var Player_chase = false
var Player = null

# music variables
@onready var Elite_sfx: AudioStreamPlayer2D = $EliteSFX
const HEAVY_SLASH = preload("res://Music/SFX/Enemies/heavy_slash.mp3")
const SHOTGUN = preload("res://Music/SFX/Enemies/shotgun.mp3")

# Animation state tracking
var current_animation: String = "Idle"

func _ready() -> void:
	Elite_sprite.play("Idle")
	current_animation = "Idle"
	Elite_los.enabled = true
	
	DashTimer.wait_time = 1
	DashTimer.one_shot = false
	DashTimer.timeout.connect(_on_dash_timer_timeout)
	DashTimer.start()
	Wait_timer.timeout.connect(_on_wait_timer_timeout)
	Elite_sprite.animation_finished.connect(_on_animation_finished)

func _physics_process(delta: float) -> void:
	if !is_dead():
		if Dashing:
			velocity = Dash_direction * Dash_speed
			move_and_collide(velocity * delta)
			return
		
		move_and_collide(velocity * delta)
		
		Shoot_timer += delta
		melee_timer += delta
		
		if Player != null and !Is_waiting:
			Elite_los.target_position = Player.global_position - global_position
			Elite_los.force_raycast_update()
			if Elite_los.is_colliding() and Elite_los.get_collider() == Player:
				Player_chase = true
				Last_direction = (Player.position - position).normalized()
			else:
				Player_chase = false
		
		# Update velocity and state
		if Player_chase and Player:
			var Direction = (Player.position - position).normalized()
			var distance_to_player = position.distance_to(Player.position)
			velocity = Direction * Speed
			
			# Attack logic: Melee if close, otherwise Ranged
			if distance_to_player <= Melee_range and melee_timer >= Melee_cooldown and !is_melee_attacking:
				start_melee_attack()
			elif Shoot_timer >= Shoot_cooldown and !is_ranged_attacking and !is_melee_attacking:
				start_ranged_attack()
			
			Rotation_offset += Rotation_speed * delta
			Rotation_offset = fmod(Rotation_offset, 360.0)
			Elite_sprite.flip_h = Player.position.x < position.x
		
		elif Is_waiting:
			velocity = Last_direction * Speed
			Elite_sprite.flip_h = Last_direction.x < 0
		else:
			velocity = Vector2.ZERO
		
		# Update animation only when state changes
		update_animation()
	else:
		enemy_dead()

func update_animation() -> void:
	var new_animation = "Idle"
	
	if is_melee_attacking:
		new_animation = "Melee_attack"
	elif is_ranged_attacking:
		new_animation = "Ranged_attack"
	elif velocity != Vector2.ZERO:
		new_animation = "Move"
	else:
		new_animation = "Idle"
	
	# Only play if the animation changes
	if new_animation != current_animation:
		Elite_sprite.play(new_animation)
		current_animation = new_animation

func start_ranged_attack() -> void:
	is_ranged_attacking = true
	Shoot_timer = 0.0
	
	var attack_speed = Elite_sprite.get_sprite_frames().get_animation_speed("Ranged_attack")
	var frame_duration = 1.0 / attack_speed
	var time_to_frame_4 = frame_duration * 6  # Adjusted to frame 4
	
	# Play sound immediately
	if Elite_sfx:
		if Elite_sfx.playing:
			Elite_sfx.stop()
		Elite_sfx.stream = SHOTGUN
		Elite_sfx.play()
	
	await get_tree().create_timer(time_to_frame_4).timeout
	shoot_projectile()
	circle_attack()

func start_melee_attack() -> void:
	is_melee_attacking = true
	melee_timer = 0.0
	
	# Play sound immediately
	if Elite_sfx:
		if Elite_sfx.playing:
			Elite_sfx.stop()
		Elite_sfx.stream = HEAVY_SLASH
		Elite_sfx.play()
	# Add melee damage logic here if needed

func _on_animation_finished() -> void:
	if Elite_sprite.animation == "Ranged_attack":
		is_ranged_attacking = false
	elif Elite_sprite.animation == "Melee_attack":
		is_melee_attacking = false
	update_animation()  # Ensure animation updates after attack ends

func shoot_projectile() -> void:
	var Direction = (Player.position - position).normalized()
	
	var ProjectileInstance = Projectile.instantiate()
	ProjectileInstance.Direction = Direction.normalized()
	ProjectileInstance.SpawnPos = global_position
	ProjectileInstance.Fired_by = self
	get_parent().add_child.call_deferred(ProjectileInstance)

func circle_attack() -> void:
	var Num_projectiles = 8
	var Angle_step = TAU / Num_projectiles
	var Angle_offset = deg_to_rad(Rotation_offset)

	for i in range(Num_projectiles):
		var Angle = i * Angle_step + Angle_offset
		var Direction = Vector2(cos(Angle), sin(Angle))

		var ProjectileInstance = Projectile.instantiate()
		ProjectileInstance.Direction = Direction.normalized()
		ProjectileInstance.Lifetime = 5.0
		ProjectileInstance.SpawnPos = global_position
		ProjectileInstance.Fired_by = self
		get_parent().add_child.call_deferred(ProjectileInstance)

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Player = body
		print("Are you ready to die?")
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
		print("Come back here Coward!")

func is_dead() -> bool:
	return Elite_health.Health <= 0

func enemy_dead() -> void:
	if current_animation != "Death":
		Elite_sprite.play("Death")
		current_animation = "Death"
		Elite_hitbox.monitoring = false
	
	var Death_animation_name : String = "Death"
	var Death_animation_speed : float = Elite_sprite.get_sprite_frames().get_animation_speed(Death_animation_name)
	var Death_animation_frames : float = Elite_sprite.get_sprite_frames().get_frame_count(Death_animation_name)
	var Death_animation_length : float = (Death_animation_frames / Death_animation_speed)
	
	await get_tree().create_timer(Death_animation_length, false, true).timeout
	queue_free()

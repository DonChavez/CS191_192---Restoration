extends Node

@export var Damage_delay: float = 0.5
@export var Shield_damage_delay: float = 1.0
@export var Damage_lerp_speed: float = 5.0

var Health_component: HealthComponent
var Shield_component: HealthComponent

var HealthBar: ProgressBar
var DamageBar: ProgressBar
var HealthLabel: RichTextLabel

var ShieldBar: ProgressBar
var ShieldDamageBar: ProgressBar

var last_health: float = 0
var damage_timer: float = 0.0
var last_shield: float = 0
var shield_damage_timer: float = 0.0

func _ready() -> void:
	_initialize_UI_elements()
	_initialize_health_component()
	_initialize_shield_component()

# ---------------- HEALTH SYSTEM ---------------- #

func _initialize_UI_elements() -> void:
	HealthBar = get_node_or_null("Health")
	DamageBar = get_node_or_null("DamageBar")
	HealthLabel = get_node_or_null("Health/CenterContainer/HealthLabel")

	ShieldBar = get_node_or_null("ShieldDurability")
	ShieldDamageBar = get_node_or_null("ShieldDamageBar")

	if not (HealthBar and DamageBar and HealthLabel and ShieldBar and ShieldDamageBar):
		push_error("Some UI elements are missing!")

func _initialize_health_component() -> void:
	var player = await _get_player_instance()
	if not player:
		return

	Health_component = player.get_node_or_null("PlayerHealth")
	if not Health_component:
		push_error("No HealthComponent found in Player!")
		return

	if not Health_component.changed.is_connected(_on_health_changed):
		Health_component.changed.connect(_on_health_changed)

	HealthBar.min_value = 0
	HealthBar.max_value = Health_component.Max_health
	HealthBar.value = Health_component.Health

	DamageBar.min_value = 0
	DamageBar.max_value = Health_component.Max_health
	DamageBar.value = Health_component.Health

	last_health = Health_component.Health
	_on_health_changed(Health_component.Health)

func _on_health_changed(new_health: float) -> void:
	if not Health_component:
		return

	HealthBar.value = new_health
	DamageBar.max_value = Health_component.Max_health
	HealthBar.max_value = Health_component.Max_health
	_update_health_label()

func _update_health_label() -> void:
	if Health_component:
		HealthLabel.text = "%d / %d" % [Health_component.Health, Health_component.Max_health]

# ---------------- SHIELD SYSTEM ---------------- #

func _initialize_shield_component() -> void:
	var player = await _get_player_instance()
	if not player:
		return

	var shield = player.get_node_or_null("TempoShield")
	if shield:
		Shield_component = shield.get_node_or_null("TSDurability")

	if not Shield_component:
		push_error("No ShieldComponent found in Player!")
		return

	if not Shield_component.changed.is_connected(_on_shield_changed):
		Shield_component.changed.connect(_on_shield_changed)

	ShieldBar.min_value = 0
	ShieldBar.max_value = Shield_component.Max_health
	ShieldBar.value = Shield_component.Health
	ShieldBar.visible = true

	ShieldDamageBar.min_value = 0
	ShieldDamageBar.max_value = Shield_component.Max_health
	ShieldDamageBar.value = Shield_component.Health
	ShieldDamageBar.visible = true

	last_shield = Shield_component.Health

func _on_shield_changed(new_shield_health: float) -> void:
	if not Shield_component:
		return

	ShieldBar.value = new_shield_health
	ShieldBar.max_value = Shield_component.Max_health
	ShieldDamageBar.max_value = Shield_component.Max_health
	ShieldBar.visible = true
	ShieldDamageBar.visible = true

# ---------------- UI ANIMATIONS ---------------- #

func _physics_process(delta: float) -> void:
	if Health_component:
		_update_damage_bar(delta)
	if Shield_component:
		_update_shield_damage_bar(delta)

func _update_damage_bar(delta: float) -> void:
	if HealthBar.value < last_health:
		last_health = HealthBar.value
		damage_timer = Damage_delay
		DamageBar.visible = true
	elif damage_timer > 0:
		damage_timer -= delta
	elif DamageBar.value > last_health:
		DamageBar.value = lerp(DamageBar.value, last_health, delta * Damage_lerp_speed)
		if abs(DamageBar.value - last_health) < 0.1:
			DamageBar.value = last_health
	else:
		DamageBar.visible = false

func _update_shield_damage_bar(delta: float) -> void:
	if ShieldBar.value < last_shield:
		last_shield = ShieldBar.value
		shield_damage_timer = Shield_damage_delay
		ShieldDamageBar.visible = true
	elif shield_damage_timer > 0:
		shield_damage_timer -= delta
	elif ShieldDamageBar.value > last_shield:
		ShieldDamageBar.value = lerp(ShieldDamageBar.value, last_shield, delta * Damage_lerp_speed)
		if abs(ShieldDamageBar.value - last_shield) < 0.1:
			ShieldDamageBar.value = last_shield
	else:
		ShieldDamageBar.visible = false

# ---------------- UTILITY ---------------- #

func _get_player_instance():
	var player = PlayerManager.Player_instance
	if not player:
		push_error("Player instance not found! Waiting...")
		await PlayerManager.Player_spawned
		player = PlayerManager.Player_instance

	if not player:
		push_error("Still couldn't find player instance!")

	return player

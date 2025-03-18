extends Node

@export var Damage_delay: float = 0.5  # Time before health damage bar starts decreasing
@export var Shield_damage_delay: float = 1.0  # Longer wait time before shield damage bar starts decreasing
@export var Damage_lerp_speed: float = 5.0  # Speed of the smooth decrease

var Health_component: HealthComponent  # Player health component
var Shield_component: HealthComponent  # Shield durability component

@onready var HealthBar: ProgressBar = $HUD/PlayerInfo/Health
@onready var DamageBar: ProgressBar = $HUD/PlayerInfo/DamageBar
@onready var HealthLabel: RichTextLabel = $HUD/PlayerInfo/Health/CenterContainer/HealthLabel  # Health text label
@onready var ShieldBar: ProgressBar = $HUD/PlayerInfo/ShieldDurability  # Shield durability bar
@onready var ShieldDamageBar: ProgressBar = $HUD/PlayerInfo/ShieldDamageBar  # Shield damage bar
@onready var LevelName: Label = $HUD/Top/Header/Timer/HBoxContainer/LevelName  # Level name label

var last_health: float = 0
var last_shield: float = 0
var damage_timer: float = 0.0
var shield_damage_timer: float = 0.0

func _ready() -> void:
	print("connecting")
	_initialize_health_components()

func _initialize_health_components() -> void:
	var player = PlayerManager.Player_instance
	if not player:
		push_error("Player instance not found!")
		return
	
	Health_component = player.get_node_or_null("PlayerHealth")
	var shield = player.get_node_or_null("TempoShield")
	if shield:
		Shield_component = shield.get_node_or_null("TSDurability")
	
	LevelName.text = player.get_parent().name if player.get_parent() else "Unknown"

	if not Health_component:
		push_error("No Health_component found in Player!")
		return

	Health_component.changed.connect(_on_health_changed)
	if Shield_component:
		Shield_component.changed.connect(_on_shield_changed)

	HealthBar.min_value = 0
	HealthBar.max_value = Health_component.Max_health
	HealthBar.value = Health_component.Health

	DamageBar.min_value = 0
	DamageBar.max_value = Health_component.Max_health
	DamageBar.value = Health_component.Health

	last_health = Health_component.Health
	_on_health_changed(Health_component.Health)

	if Shield_component:
		ShieldBar.min_value = 0
		ShieldBar.max_value = Shield_component.Max_health
		ShieldBar.value = Shield_component.Health
		ShieldBar.visible = true

		ShieldDamageBar.min_value = 0
		ShieldDamageBar.max_value = Shield_component.Max_health
		ShieldDamageBar.value = Shield_component.Health
		ShieldDamageBar.visible = true

		last_shield = Shield_component.Health

func _physics_process(delta: float) -> void:
	if not Health_component:
		return

	if HealthBar.value != last_health:
		last_health = HealthBar.value
		damage_timer = Damage_delay
		DamageBar.visible = true
	else:
		if damage_timer > 0:
			damage_timer -= delta
		elif DamageBar.value > HealthBar.value:
			DamageBar.value = lerp(DamageBar.value, HealthBar.value, delta * Damage_lerp_speed)
			if abs(DamageBar.value - HealthBar.value) < 0.1:
				DamageBar.value = HealthBar.value
		else:
			DamageBar.visible = false

	if Shield_component and ShieldBar.value != last_shield:
		last_shield = ShieldBar.value
		shield_damage_timer = Shield_damage_delay
		ShieldDamageBar.visible = true
	else:
		if shield_damage_timer > 0:
			shield_damage_timer -= delta
		elif ShieldDamageBar.value > ShieldBar.value:
			ShieldDamageBar.value = lerp(ShieldDamageBar.value, ShieldBar.value, delta * Damage_lerp_speed)
			if abs(ShieldDamageBar.value - ShieldBar.value) < 0.1:
				ShieldDamageBar.value = ShieldBar.value
		else:
			ShieldDamageBar.visible = false

func _on_health_changed(new_health: float) -> void:
	if not Health_component:
		return

	HealthBar.value = new_health
	HealthBar.max_value = Health_component.Max_health
	DamageBar.max_value = Health_component.Max_health
	_update_health_label()

func _on_shield_changed(new_shield_health: float) -> void:
	if not Shield_component:
		return

	ShieldBar.value = new_shield_health
	ShieldBar.max_value = Shield_component.Max_health
	ShieldDamageBar.max_value = Shield_component.Max_health

	ShieldBar.visible = true
	ShieldDamageBar.visible = true

func _update_health_label() -> void:
	if not Health_component:
		return

	HealthLabel.text = "%d / %d" % [Health_component.Health, Health_component.Max_health]

func _on_level_loaded() -> void:
	_initialize_health_components()
	call_deferred("_update_level_name")


		

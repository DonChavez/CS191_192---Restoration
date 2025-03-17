extends ProgressBar

@export var Health_component: HealthComponent
@export var Damage_delay: float = 0.5  # Time before damage bar starts decreasing
@export var Damage_lerp_speed: float = 5.0  # Speed of the smooth decrease

@onready var DamageBar: ProgressBar = $DamageBar  # Reference to DamageBar
var last_health: float = 0
var damage_timer: float = 0.0  # Timer to track when to update damage bar
var is_damaging: bool = false  # Tracks if health is still changing

func _ready() -> void:
	if not Health_component:
		push_error("No health component assigned for health bar: ", get_parent())
		return

	# Connect to health change signal
	Health_component.changed.connect(_on_health_changed)

	# Set up DamageBar values
	DamageBar.min_value = 0
	DamageBar.max_value = Health_component.Max_health
	DamageBar.value = Health_component.Health

	# Set main bar values
	min_value = 0
	max_value = Health_component.Max_health
	value = Health_component.Health
	last_health = Health_component.Health

	# Set colors based on entity type
	var Style_box = StyleBoxFlat.new()
	if Health_component.get_parent().is_in_group("Player"):
		Style_box.bg_color = Color.GREEN
	elif Health_component.get_parent().is_in_group("Shield"):
		Style_box.bg_color = Color.BLUE
	else:
		Style_box.bg_color = Color.RED
	add_theme_stylebox_override("fill", Style_box)

	# Initialize the health bar
	_on_health_changed(Health_component.Health)

func _process(delta: float) -> void:
	# If health has changed recently, reset the damage timer
	if value != last_health:
		last_health = value
		damage_timer = Damage_delay  # Reset delay timer
		is_damaging = true  # Player is taking damage
	else:
		# Countdown the timer if no new damage
		if damage_timer > 0:
			damage_timer -= delta
		elif DamageBar.value > value:
			# Smoothly decrease DamageBar using lerp when the timer expires
			DamageBar.value = lerp(DamageBar.value, value, delta * Damage_lerp_speed)
			is_damaging = false  # Damage is no longer incoming

func _on_health_changed(New_health: float) -> void:
	value = New_health  # Main health bar updates instantly
	max_value = Health_component.Max_health  # Adjust max value dynamically
	DamageBar.max_value = Health_component.Max_health  # Sync max value

	# Ensure visibility is correct based on absolute health values
	visible = New_health > 0 and New_health < Health_component.Max_health

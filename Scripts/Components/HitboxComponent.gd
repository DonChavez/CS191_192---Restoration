extends Area2D
class_name HitboxComponent

# Hitbox component will be the one that receives damage

# Signals
signal damaged(Amount: float)

# Exportable variables
@export var Health: HealthComponent  # Reference to health
@export var Damage_interval: float = 0.1  # Time before taking damage again
@export var Substitute_damage: float = 0  # Force entities to take a certain amount of damage
# @export var interaction_sound: AudioStreamPlayer2D  # Sound on hit

# Local variables
var Time_since_last_damage: float = 0.0

func damage_received(Amount: float) -> void:
	# only take damage if cooldown has passed
	if Health and Time_since_last_damage >= Damage_interval:
		if Substitute_damage != 0:
			Amount = Substitute_damage
		Health.take_damage(Amount)  # apply damage
		damaged.emit(Amount)
		# if interaction_sound:
		# 	interaction_sound.play()  # play hit sound
		Time_since_last_damage = 0.0  # reset cooldown
		
func _physics_process(delta: float) -> void:
	if Time_since_last_damage < Damage_interval:
		Time_since_last_damage += delta

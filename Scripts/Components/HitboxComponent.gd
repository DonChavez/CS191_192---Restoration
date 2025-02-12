extends Area2D
class_name HitboxComponent

signal damaged(amount: float)  # Signal for taking damage

@export var health_component: HealthComponent  # Reference to health
@export var interaction_sound: AudioStreamPlayer2D  # Sound on hit

func damage_received(amount: float) -> void:
	if health_component and not health_component.is_invulnerable:  # Check if vulnerable
		health_component.take_damage(amount)  # Apply damage
		damaged.emit(amount)  # Emit damage signal
		if interaction_sound:
			interaction_sound.play()  # Play hit sound

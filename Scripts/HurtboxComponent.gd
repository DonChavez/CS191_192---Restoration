extends Area2D
class_name HurtboxComponent

signal damaged(amount: float)

@export var health_component: HealthComponent
@export var interaction_sound: AudioStreamPlayer2D

func damage_received(amount: float) -> void:
	if health_component:
		health_component.take_damage(amount)
		damaged.emit(amount)
		if interaction_sound:
			interaction_sound.play()  
		

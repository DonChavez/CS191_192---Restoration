extends Area2D
class_name HurtboxComponent

signal damaged(amount: float)

@export var health_component: HealthComponent

func damage_received(amount: float) -> void:
	if health_component:
		health_component.take_damage(amount)
		damaged.emit(amount)

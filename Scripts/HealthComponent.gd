extends Node2D
class_name HealthComponent

signal changed(health: float)
signal damage_taken(amount: float)
signal died()

@export var max_health: float = 100.0
var health: float = 0.0

func _ready() -> void:
	health = max_health

func take_damage(amount: float) -> void:
	var old_health: float = health
	health = max(0, health - amount)

	damage_taken.emit(old_health - health)
	changed.emit(health)

	if is_dead():
		died.emit()

func is_dead() -> bool:
	return health <= 0

func is_alive() -> bool:
	return health > 0

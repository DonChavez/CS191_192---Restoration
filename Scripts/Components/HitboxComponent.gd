extends Area2D
class_name HitboxComponent

signal damaged(Amount: float)

@export var Health: HealthComponent
@export var Damage_interval: float = 0.1
@export var Substitute_damage: float = 0
@export var Damage_reduction: float = 0

var Time_since_last_damage: float = 0.0
var last_attacker_position: Vector2 = Vector2.ZERO  # NEW

func damage_received(Amount: float, Attacker_position: Vector2 = Vector2.ZERO) -> float:
	last_attacker_position = Attacker_position  # NEW

	var Damage_taken = 0
	if Health and Time_since_last_damage >= Damage_interval:
		if Substitute_damage != 0:
			Amount = Substitute_damage
		Damage_taken = Amount * (1 - Damage_reduction)
		Health.take_damage(Damage_taken)
		damaged.emit(Damage_taken)
		Time_since_last_damage = 0.0
	return Damage_taken
	
	
		
func _physics_process(delta: float) -> void:
	if Time_since_last_damage < Damage_interval:
		Time_since_last_damage += delta

func set_damage_reduction(Amount: float):
	Damage_reduction = Amount

func get_damage_reduction() -> float:
	return Damage_reduction

extends Area2D
class_name HurtboxComponent

signal hit(hitbox: HitboxComponent, amount: float)  # Signal for hit event

@export var damage_amount: float = 1.0  # Damage dealt

func _ready() -> void:
	area_entered.connect(_on_hitbox_entered)  # Detect collisions

func _on_hitbox_entered(area: Area2D) -> void:
	if area is HitboxComponent and monitoring:  # Check if valid hitbox
		var hitbox: HitboxComponent = area
		hitbox.damage_received(damage_amount)  # Apply damage
		hit.emit(hitbox, damage_amount)  # Notify listeners

extends Area2D
class_name HitboxComponent

signal hit(hurtbox: HurtboxComponent, amount: float)

@export var damage_amount: float = 1.0

func _ready() -> void:
	area_entered.connect(_on_hurtbox_entered)

func _on_hurtbox_entered(area: Area2D) -> void:
	if area is HurtboxComponent:
		print("Player received 1 damage!")
		var hurtbox: HurtboxComponent = area
		hurtbox.damage_received(damage_amount)
		hit.emit(hurtbox, damage_amount)
		
		

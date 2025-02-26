extends Area2D
class_name HurtboxComponent

signal hit(hitbox: HitboxComponent, amount: float)

@export var damage_amount: float = 1.0
@export var damage_interval: float = 0.2  

var time_since_last_damage: float = 0.0
var hitbox: HitboxComponent = null

func _ready() -> void:
	area_entered.connect(_on_hitbox_entered)
	area_exited.connect(_on_hitbox_exited)

func _on_hitbox_entered(area: Area2D) -> void:
	if area is HitboxComponent:
		hitbox = area
		hitbox.damage_received(damage_amount)
		hit.emit(hitbox, damage_amount)
		time_since_last_damage = 0.0

func _on_hitbox_exited(area: Area2D) -> void:
	if area is HitboxComponent and hitbox == area:
		hitbox = null

func _process(delta: float) -> void:
	if hitbox:
		time_since_last_damage += delta
		if time_since_last_damage >= damage_interval:
			if hitbox.has_method("damage_received"):
				hitbox.damage_received(damage_amount)
				hit.emit(hitbox, damage_amount)
				time_since_last_damage = 0.0

extends Node2D

# onready variables
@onready var TP_sprite: Sprite2D = $TrashPileSprite
@onready var TP_health: HealthComponent = $TrashPileHealth
@onready var TP_hitbox: HitboxComponent = $TrashPileHitbox
@onready var TP_trashtype: Array = []


func _ready() -> void:
	# default animation start
	pass

func _physics_process(delta: float) -> void:
	if is_dead():
		object_destroyed()

func is_dead() -> bool: 
	return TP_health.Health <= 0

func object_destroyed() -> void:
	# ensure enemy doesn't take more damage
	TP_hitbox.monitoring = false	
	queue_free()


func _on_trash_pile_health_damage_taken(Amount: float) -> void:
	#Spawn trash scenes
	pass

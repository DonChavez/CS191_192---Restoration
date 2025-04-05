extends Node2D

#-----onready variables-----#
@onready var Log_health: HealthComponent = $LogHealth
@onready var Log_hitbox: HitboxComponent = $LogHitbox
@onready var Trash_spawn: Node = $TrashSpawn

#-----export variables-----#
@export var Trash_to_spawn: int = 2

func _ready() -> void:
	Log_hitbox.monitorable = true
	Log_hitbox.monitoring = true

func _process(delta: float) -> void:
	if is_dead():
		object_destroyed()

func is_dead() -> bool: 
	return Log_health.Health <= 0

func object_destroyed() -> void:
	Trash_spawn.spawn_trash(Trash_to_spawn)
	Log_hitbox.monitorable = false
	Log_hitbox.monitoring = false
	queue_free()

extends Node2D

# onready variables
@onready var TP_sprite: Sprite2D = $TrashPileSprite
@onready var TP_health: HealthComponent = $TrashPileHealth
@onready var TP_hitbox: HitboxComponent = $TrashPileHitbox
@onready var TP_trashspawn: Dictionary = {
	preload("res://Scenes/TrashMedium.tscn")	: 30,
	preload("res://Scenes/TrashSmall.tscn")	: 60,
	null										: 10
}




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


func get_random_trash() -> PackedScene:
	var Random_pick = randi_range(1, 100)  # Always between 1 and 100
	var Current_sum = 0

	for Obj in TP_trashspawn:
		Current_sum += TP_trashspawn[Obj]  # Add percentage chance
		if Random_pick <= Current_sum:
			return Obj  # Return selected object

	return null  # Should never happen unless dictionary is empty



func _on_trash_pile_health_damage_taken(Amount: float) -> void:
	#Spawn trash scenes
	var Trash_scene = get_random_trash()
	if !Trash_scene:
		return
	var Trash_instance = Trash_scene.instantiate()
	
	Trash_instance.global_position = self.global_position+Vector2(0,20)

	var World_scene = get_tree().current_scene  # Get current game world
	World_scene.add_child(Trash_instance)  # Move to world
	
	

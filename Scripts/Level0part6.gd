extends Node2D

@export var Portal_to_hub = load("res://Scenes/Interactables/Portal.tscn")
@export var Target_level_path : String = "res://Scenes/Levels/TestingArea/HubTestingArea.tscn"

var Boss_defeated : bool = false
var Portal_spawned : bool = false

# used to get the UI
func _ready() -> void:
	pass # Replace with function body.
	#Portal_to_hub.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	check_conditions()

func check_conditions() -> void: 
	# Check if boss is defeated by looking at children
	var Boss_exists = false
	for Child in get_children():
		if Child.is_in_group("Boss"):
			Boss_exists = true
			break
	Boss_defeated = Boss_exists

# Check both conditions and spawn portal if not already spawned
	if !Boss_defeated and !Portal_spawned:
		spawn_portal()
		Portal_spawned = true  # Prevent multiple spawns

func spawn_portal() -> void: 
	var Portal_instance = Portal_to_hub.instantiate()
	Portal_instance.Target_level_path = Target_level_path
	Portal_instance.position = Vector2(478, -46)
	add_child(Portal_instance)

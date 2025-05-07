extends Node2D

@export var Portal_to_hub = load("res://Scenes/Interactables/Portal.tscn")
@export var Target_level_path : String = "res://Scenes/Levels/TestingArea/NewHubArea.tscn"
@export var X_Portal : int = 478
@export var Y_Portal : int = -46

@export var Dialogue_resource : DialogueResource
@export var Dialogue_start : String = ""

var Boss_defeated : bool = false
var Portal_spawned : bool = false

## used to get the UI
#func _ready() -> void:
	#print("We are in this level currently!")
	#print(get_tree().current_scene.name)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	check_conditions()
	#print("We are in this level currently!")
	#print(get_tree().current_scene.name)

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
		var pollution_level = PlayerManager.Player_instance.get_node_or_null("UI Wrapper/HUD/Top/Header/PollutionSystem").Current_pollution
			
		if pollution_level <= 50:
			spawn_portal()
			Portal_spawned = true  # Prevent multiple spawns
		print("Boss is dead!")

func spawn_portal() -> void: 
	var Portal_instance = Portal_to_hub.instantiate()
	Portal_instance.Target_level_path = Target_level_path
	Portal_instance.position = Vector2(X_Portal, Y_Portal)
	get_tree().current_scene.add_child(Portal_instance)
	DialogueManager.show_example_dialogue_balloon(Dialogue_resource, Dialogue_start)
	

extends Node

#-----onready variables-----#
@onready var Parent = $".."

#-----export variables-----#
@export var Trash_spawn: Dictionary = {
	preload("res://Scenes/Interactables/TrashMedium.tscn")	: 30,
	preload("res://Scenes/Interactables/TrashSmall.tscn")	: 60,
	null										: 10
}

# Acquire a random trash scene depending on chance from Trash_Spawn
func get_random_trash() -> PackedScene:
	var Random_pick = randi_range(1, 100)  # Always between 1 and 100
	var Current_sum = 0

	for Obj in Trash_spawn:
		Current_sum += Trash_spawn[Obj]  # Add percentage chance
		if Random_pick <= Current_sum:
			return Obj  # Return selected object

	return null  # Should never happen unless dictionary is empty

# Spawn Amount of random Trash in the world
func spawn_trash(Amount: int) -> void:
	#Spawn trash scenes
	var World_scene = get_tree().current_scene  # Get current game world

	for I in range(Amount):
		var Trash_scene = get_random_trash()
		if !Trash_scene:
			continue
		var Trash_instance = Trash_scene.instantiate()
		
		Trash_instance.global_position = Parent.global_position+Vector2(0,20)

		World_scene.add_child(Trash_instance)  # Move to world
		

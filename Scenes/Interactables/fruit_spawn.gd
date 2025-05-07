extends Node

#-----onready variables-----#
@onready var Parent = $".."

#-----export variables-----#
@export var Fruit_spawn = preload("res://Scenes/Objects/Healing Items/Apple.tscn")

func spawn_fruit(Amount : int) -> void:
	
	var World_scene = get_tree().current_scene  # Get current game world
	
	for i in range(Amount):
		var Fruit_instance = Fruit_spawn.instantiate() # create coin instance
		
		Fruit_instance.Spawn_animate = true
		
		Fruit_instance.global_position = Parent.global_position+Vector2(0,20)

		World_scene.add_child(Fruit_instance)  # Move to world

extends Node

#-----onready variables-----#
@onready var Parent = $".."

#-----export variables-----#
@export var Coin_spawn = preload("res://Scenes/Interactables/Coin.tscn")

func spawn_coin(Amount : int) -> void: 
	# gimme the money
	var World_scene = get_tree().current_scene  # Get current game world
	
	for i in range(Amount):
		var Coin_instance = Coin_spawn.instantiate() # create coin instance
		
		Coin_instance.Spawn_animate = true
		
		Coin_instance.global_position = Parent.global_position+Vector2(0,20)

		World_scene.add_child(Coin_instance)  # Move to world

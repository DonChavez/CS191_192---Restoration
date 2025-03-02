extends Node2D
# class_name allows us to inherit functions/values in to or from other nodes
class_name HealthComponent

# signals
# signal stating that the player took damage -> used for damage animation
signal damage_taken(Amount: float)
# signal stating the player healed -> used for regeneration
signal regen(Amount : float)
# changed is used for the health label
signal changed(health: float)
'''
Used in: 
	PlayerCharacter.gd -> handle the death animation
	Enemy.gd -> handle the death animation
'''

# exportable variables
@export var Max_health: float = 100.0 # can be changed anytime
@export var Is_object_blocking : bool = false
@export var Is_object_parrying : bool = false
@export var Is_object_healing : bool = false

# local variables
var Health: float = 0.0

func _ready() -> void:
	# initialize health to be currently on max health
	Health = Max_health
	changed.emit(Health)

func take_damage(Amount : float) -> void: 
	# immediately return if health is 0
	if Health == 0: return
	# subtract the health by the amount of damage taken
	if !Is_object_blocking:
		if Is_object_healing or Is_object_parrying:
			Health += Amount
		else:
			Health -= Amount
		changed.emit(Health)

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
# signal to see if the health reaches 0
signal died
'''
Used in: 
	PlayerCharacter.gd -> handle the death animation
	Enemy.gd -> handle the death animation
'''

# exportable variables
@export var Max_health: float = 100.0 # can be changed anytime
@export var Is_invulnerable : bool = false

# local variables
var Health: float = 0.0
var Is_dead: bool = false

func _ready() -> void:
	# initialize health to be currently on max health
	Health = Max_health
	changed.emit(Health)

func take_damage(Amount : float) -> void: 
	# immediately return if health is 0
	if Health == 0: return
	# subtract the health by the amount of damage taken
	if !Is_invulnerable:
		Health -= Amount
		changed.emit(Health)
		damage_taken.emit(Amount)
		
		if Health <= 0:
			Health = 0
			Is_dead = true
			died.emit()
		
func heal(Amount: float) -> void:
	# prevent from healing when dead
	
	if Is_dead:
		return
	# heal health by a certain amount
	print("I healed: ", Amount)
	Health += Amount
	# ensures that health does not exceed max_health
	Health = min(Health, Max_health)  
	regen.emit(Amount)
	changed.emit(Health)

func set_new_health(Amount: float) -> void:
	var Health_added = Amount - Max_health
	Max_health = Amount
	if Health_added > 0:
		heal(Health_added)
	print(Max_health)

func get_health() -> Array[float]:
	return [Health,Max_health]

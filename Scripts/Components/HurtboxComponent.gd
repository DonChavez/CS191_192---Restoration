extends Area2D
# class_name allows us to inherit functions/values in to or from other nodes
class_name HurtboxComponent
# hurtbox component will be the one that deals the damage

# signals
# hit signal 
signal hit(Hitbox: HitboxComponent, amount: float)  # Signal for hit event
signal success  # Signal for hit event
signal damage_dealt(Amount: float)

# exports
@export var Damage_amount: float = 20.0  # Damage dealt
@export var Damage_interval: float = 0.1

# local variables
var Time_since_last_damage: float = 0.0
var Hitbox_dict = {}
var Hitbox_list: Array[HitboxComponent] = []
var Processing_list: Array[HitboxComponent] = []
var Success_checker: bool = false

func _ready() -> void:
	# if player hitbox collision is entered by another hitbox component, it calls the on_hitbox_entered function
	# area_entered is defined in godot
	area_entered.connect(_on_hitbox_entered)  # Detect collisions
	area_exited.connect(_on_hitbox_exited)

func _on_hitbox_entered(Area: Area2D) -> void:
	# check if the area entered is a hitbox
	# essentially 2-factor authentication
	print(Area)
	if Area is HitboxComponent and monitoring:  # Check if valid hitbox
		Hitbox_dict[Area] = Damage_interval
		Hitbox_list.append(Area)
		print("Target")
		#Hitbox.damage_received(Damage_amount)  # Apply damage
		# animation signal
		# tells the player they were hit
		#hit.emit(hitbox, damage_amount)  # Notify listeners
		
func _on_hitbox_exited(Area: Area2D) -> void:
	if Area is HitboxComponent and Area in Hitbox_dict:
		Hitbox_dict.erase(Area)
		Processing_list.erase(Area)

func _physics_process(delta: float) -> void:
	if Hitbox_list:
		Processing_list.append(Hitbox_list.pop_front())
	
	if monitoring:
		if Processing_list:
			if Success_checker:		# For checking consecutive hits
				success.emit()
				Success_checker = false
			for Hitbox in Processing_list:
				Hitbox_dict[Hitbox] += delta
				if Hitbox_dict[Hitbox] >= Damage_interval:
					if Hitbox.has_method("damage_received"):
						var Damage_dealt: float = Hitbox.damage_received(Damage_amount)
						damage_dealt.emit(Damage_dealt)
						hit.emit(Hitbox, Damage_amount)
						Hitbox_dict[Hitbox] = 0.0
					
func hurtbox_implement_damage(Amount: float) -> void:
	Damage_amount = Amount
func apply_interval(Amount:float) -> void:
	Damage_interval = Amount
func success_check() -> void:# For checking consecutive hits
	Success_checker = true

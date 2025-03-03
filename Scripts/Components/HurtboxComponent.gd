extends Area2D
# class_name allows us to inherit functions/values in to or from other nodes
class_name HurtboxComponent
# hurtbox component will be the one that deals the damage

# signals
# hit signal 
signal hit(Hitbox: HitboxComponent, amount: float)  # Signal for hit event

# exports
@export var Damage_amount: float = 20.0  # Damage dealt
@export var Damage_interval: float = 0.1

# local variables
var Time_since_last_damage: float = 0.0
var Hitbox: HitboxComponent = null

func _ready() -> void:
	# if player hitbox collision is entered by another hitbox component, it calls the on_hitbox_entered function
	# area_entered is defined in godot
	area_entered.connect(_on_hitbox_entered)  # Detect collisions
	area_exited.connect(_on_hitbox_exited)

func _on_hitbox_entered(Area: Area2D) -> void:
	# check if the area entered is a hitbox
	# essentially 2-factor authentication
	if Area is HitboxComponent and monitoring:  # Check if valid hitbox
		Hitbox = Area
		Time_since_last_damage = Damage_interval
		#Hitbox.damage_received(Damage_amount)  # Apply damage
		# animation signal
		# tells the player they were hit
		#hit.emit(hitbox, damage_amount)  # Notify listeners
		
func _on_hitbox_exited(Area: Area2D) -> void:
	if Area is HitboxComponent and Hitbox == Area:
		Hitbox = null

func _physics_process(delta: float) -> void:
	if Hitbox and monitoring:
		Time_since_last_damage += delta
		if Time_since_last_damage >= Damage_interval:
			if Hitbox.has_method("damage_received"):
				print("I deal damage")
				Hitbox.damage_received(Damage_amount)
				hit.emit(Hitbox, Damage_amount)
				Time_since_last_damage = 0.0

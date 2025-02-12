extends Area2D

# Enum to represent the different object types
enum ObjectType { INTERACTABLE, GATHERABLE, COLLECTABLE }
@export var object_type : ObjectType = ObjectType.INTERACTABLE

@onready var interaction_sound = $AudioStreamPlayer2D
@onready var prompt_label = null
@onready var animated_sprite = $AnimatedSprite2D
@onready var inventory_manager = %InventoryManager

var player_nearby = false

# Called when the node enters the scene tree for the first time
func _ready():
	# Check if the Label and AudioStreamPlayer2D nodes exist
	prompt_label = $Label if has_node("Label") else null
	
	# Hide the prompt label for interactable and gatherable by default
	if prompt_label:
		prompt_label.visible = false

# This method is used to handle interactions
func interact() -> void:
	match object_type:
		ObjectType.INTERACTABLE:
			print("Interacted with the object!")
			if interaction_sound:
				interaction_sound.play()  # Play sound if required
			inventory_manager.add_coin()  # Handle the interaction (add coin or any other effect)
		ObjectType.GATHERABLE:
			print("Gathered the object!")
			if interaction_sound:
				interaction_sound.play()  # Play sound if required
				await interaction_sound.finished
			inventory_manager.add_coin()  # Handle the gathering (add coin or any other effect)
			queue_free()  # Remove the object after gathering
		ObjectType.COLLECTABLE:
			print("Collected the object!")
			if interaction_sound:
				interaction_sound.play()
				await interaction_sound.finished 
			inventory_manager.add_coin()  # Handle the collection (add coin or any other effect)
			# Wait for the sound to finish before removing the object
			queue_free()  # Remove the object after collection

# Called every frame
func _process(_delta: float) -> void:
	if player_nearby and object_type != ObjectType.COLLECTABLE and Input.is_action_just_pressed("interact"):
		interact()

# Called when a body enters the area
func _on_body_entered(_body: Node) -> void:
	player_nearby = true
	if object_type == ObjectType.COLLECTABLE:
		# Automatically interact when the player enters the area of a collectable
		interact()
	elif object_type != ObjectType.COLLECTABLE and prompt_label:
		prompt_label.visible = true  # Show prompt label for interactable and gatherable objects

# Called when a body exits the area
func _on_body_exited(_body: Node2D) -> void:
	player_nearby = false
	if object_type != ObjectType.COLLECTABLE and prompt_label:
		prompt_label.visible = false  # Hide prompt label for interactable and gatherable objects

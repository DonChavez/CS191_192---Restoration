extends Node2D
class_name Trash

"""
This is not used and may be deleted in the future

"""
@onready var Input_label = $InputLabel
@export var trash_value: int  # Set in each scene

var Player: CharacterBody2D = null  
var Inventory: InventoryObject = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input_label.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	# Remove if interacted with
	if Input_label.visible and Input.is_action_just_pressed("interact"):
		_clean_trash()

func _clean_trash() -> void:
	Inventory.add_trash(trash_value)
	print("Cleaned!")
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	Input_label.visible = true
	Player = body
	Inventory = Player.get_inventory()

func _on_area_2d_body_exited(body: Node2D) -> void:
	Input_label.visible = false
	Player = null
	Inventory = null

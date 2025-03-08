extends Node2D

enum Existence { WORLD, INVENTORY, SHOP}
@onready var Item_manager = get_tree().current_scene.get_node("Item_Manager")
@onready var Input_label = $InputLabel
@onready var Item_ID:String = ""
@onready var Exist_in: Existence = Existence.WORLD 
@onready var Stackable: bool = false


# Other Nodes
@onready var Player: CharacterBody2D = null  
@onready var Inventory: InventoryObject = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input_label.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(Delta: float) -> void:	# Add to Inventory if interacted
	if Exist_in == Existence.WORLD:
		if Input_label.visible and Input.is_action_just_pressed("interact"):
			Inventory.add_item(self)

# Pick up button appears
func _on_area_2d_body_entered(Body: Node2D):
	if !Player: # Creates connection between Item and Inventory
		Player = Body
		Inventory = Player.get_inventory()
	if Exist_in == Existence.WORLD:
		Input_label.visible = true

# Pick up button disappears
func _on_area_2d_body_exited(Body: Node2D):
	if Exist_in == Existence.WORLD:
		Input_label.visible = false

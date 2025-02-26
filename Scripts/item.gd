extends Node2D

enum Existence { WORLD, INVENTORY, SHOP}
@onready var Inventory_manager = get_tree().current_scene.get_node("PlayerCharacter/InventoryManager")
@onready var Item_manager = get_tree().current_scene.get_node("Item_Manager")
@onready var Input_label = $InputLabel
@onready var Item_ID:String = ""
@onready var Exist_in: Existence = Existence.WORLD 
@onready var Stackable: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input_label.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	# Add to Inventory if interacted
	if Exist_in == Existence.WORLD:
		if Input_label.visible and Input.is_action_just_pressed("interact"):
			send_to_inventory(self)
			
func send_to_inventory(Item: Node2D):
	Item.visible = false  # Hide it in the world
	Item.Exist_in = Existence.INVENTORY  # Update state
	Inventory_manager.add_item(self)

func dropped_item():	# Place back in world, correct attributes
	Exist_in = Existence.WORLD 
	Input_label.visible = false

# Pick up button appears
func _on_area_2d_body_entered(body: Node2D):
	if Exist_in == Existence.WORLD:
		Input_label.visible = true

# Pick up button disappears
func _on_area_2d_body_exited(body: Node2D):
	if Exist_in == Existence.WORLD:
		Input_label.visible = false

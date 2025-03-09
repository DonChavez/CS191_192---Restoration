extends Node2D

@onready var Input_label = $InputLabel
@onready var RecyclerUI = $RecyclerUI
@onready var Recycler_slots1 = $RecyclerUI/RecyclerPanel/CenterContainer/RecyclerGrid.get_children() #Slots
@onready var Recycler_slots2 = $RecyclerUI/RecyclerPanel/CenterContainer2/RecyclerGrid2.get_children() #Slots
@onready var Item_manager = $ItemManager

@onready var Player: CharacterBody2D = null  
@onready var Inventory: InventoryObject = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for I in range(Recycler_slots1.size()):
		Recycler_slots1[I].set_index(I) 
		Recycler_slots1[I].set_id(0) 

	for I in range(Recycler_slots2.size()):
		Recycler_slots2[I].set_index(I) 
		Recycler_slots2[I].set_id(1) 
		
	Input_label.visible = false
	RecyclerUI.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	# Remove if interacted with
	if Input_label.visible and Input.is_action_just_pressed("interact"):
		RecyclerUI.toggle_recycler()
		RecyclerUI.update_trash(Inventory.Trash)

# Interact button appears
func _on_area_2d_body_entered(Body: Node2D) -> void:
	Input_label.visible = true
	Player = Body
	Inventory = Player.get_inventory()

# Interact button disappears
func _on_area_2d_body_exited(Body: Node2D) -> void:
	Input_label.visible = false
	RecyclerUI.visible = false

# drop/spawn an item in world
func drop_item(Item_instance: Node2D):
	
	Item_instance.global_position = self.global_position+Vector2(0,70)
	Item_instance.visible = true  # Ensure it's visible in the world

	var World_scene = get_tree().current_scene  # Get current game world
	World_scene.add_child(Item_instance)  # Move to world

# Get random item depending on which button clicked
func _on_recycler_button_clicked(Index: int, ID: int) -> void:
	var Item_category_map = {	# Temp printing
		0: {
			0: "Common Item",
			1: "Uncommon Item",
			2: "Rare Item"
		},
		1: {
			0: "Epic Item",
			1: "Legendary Item"
		}
	}
	# Cost mapping
	var Item_cost_map = {
		0: {
			0: 1,
			1: 5,
			2: 10,
		},
		1: {
			0: 25,
			1: 50
		}
	}
	var Item: Node2D
	var Cost: int = Item_cost_map[ID][Index]
	# Get Item, Subtract Inventory trash, Update RecyclerUI
	if Inventory.Trash >= Cost:
		Item = Item_manager.get_random_item(Index + (ID * 3))
		print(Item_category_map[ID][Index])
		Inventory.add_trash(-Cost)
		RecyclerUI.update_trash(Inventory.Trash)
		drop_item(Item) # self method
	else:
		print("Not enough trash")

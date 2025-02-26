extends Node2D

@onready var Inventory_ui = $"InventoryUI"
@onready var Inventory_slots = %InventoryGrid.get_children() # Slots
@onready var Inventory_slot_num: int = Inventory_slots.size() # number of slots
@onready var Item_manager = %Item_Manager
var Items: Array = []
var Coins: int = 0
var Trash: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():	# Empty inventory at the start (Can Change in future)
	for I in range(Inventory_slot_num):
		Items.append(null)  # Empty slot
		Inventory_slots[I].set_index(I) # Sets the index of each slot (item_slot)
	Inventory_ui.update_inventory() # InventoryUI updates UI (child)
	Inventory_ui.visible=false

# Get item from inventory (Mostly used by InventoryUI)
func get_item(Index):
	if Index >= 0 and Index < Inventory_slot_num:
		return Items[Index]
	return null

# Add an item to the inventory
func add_item(Item_data: Node2D) -> bool:
	if Item_data.get_parent():  # Check if the item has a parent
		Item_data.get_parent().remove_child(Item_data)  # Remove it first
		
	self.add_child(Item_data) # Creates Item Node under Inventory_Manager
	
	for I in range(Inventory_slot_num):
		if Items[I] == null:  # Find empty slot in the Inventory
			Items[I] = Item_data
			print("Added:", Item_data["name"])
			Inventory_ui.update_inventory() # InventoryUI update (child)
			return true  # Item added successfully
	print("Inventory Full!")
	return false  # No space available

# Increment when collecting coins
func add_coin(Number: int):
	Coins += Number
	Inventory_ui.update_coin(Coins) # InventoryUI update (child)

# Increment when collecting trash
func add_trash(Number: int):
	Trash += Number
	Inventory_ui.update_trash(Trash) # InventoryUI update (child)

# Drop an item into the world
func drop_item(Index: int):
	# Retrieve the item node from the inventory array
	var Item_instance = Items[Index]
	if not Item_instance:
		print("No item at index:", Index)
		return
	Items[Index] = null  # Remove from inventory
	
	var world_scene = get_tree().current_scene  # Get current game world
	
	if Item_instance.get_parent():  # Ensure it's removed from InventoryManager
		Item_instance.get_parent().remove_child(Item_instance)

	world_scene.add_child(Item_instance)  # Move to world
	
	Item_instance.global_position = self.global_position+Vector2(200,100) # Constant to be near player
	Item_instance.visible = true  # Ensure it's visible in the world

	Item_instance.dropped_item() # Method of an Item node to make sure the Item knows its in world
	Inventory_ui.update_inventory() # InventoryUI (child)

# Clicking on an item means to remove for now (signalled by ItemSlot)
func _on_item_slot_clicked(Index: int, ID:int) -> void:
	if Index < 0 or Index >= Items.size():
		print("Invalid inventory index:", Index)
		return
	drop_item(Index)

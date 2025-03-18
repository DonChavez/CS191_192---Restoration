extends Control
# class_name allows us to inherit functions/values in to or from other nodes
class_name InventoryObject

#-----onready variables-----#
@onready var Inventory_ui = $InventoryUI
@onready var Inventory_slots = $InventoryUI/InventoryPanel/ScrollContainer/CenterContainer/InventoryGrid.get_children() # Slots
@onready var Inventory_slot_num: int = Inventory_slots.size() # number of slots
@onready var Player: CharacterBody2D = get_parent().get_parent()

# Inventory Configuration
@onready var Items: Array = []
@onready var Coins: int = 0
@onready var Trash: int = 0
@onready var Selected: int = 0

enum Existence { WORLD, INVENTORY, SHOP}


# Called when the node enters the scene tree for the first time.
func _ready():	# Empty inventory at the start (Change)
	for I in range(Inventory_slot_num):
		Items.append(null)  # Empty slot
		Inventory_slots[I].set_index(I) # Sets the index of each slot (item_slot)
	Inventory_ui.update_inventory() # InventoryUI updates UI (child)

func _process(Delta: float) -> void:
	if Input.is_action_just_pressed("inventory"):
		Inventory_ui.toggle_inventory()
		_reset_item_slot(Selected)
		Player.Can_process_input = !Player.Can_process_input

# Updates collectible amounts
func add_coin(Amount: int):
	Coins += Amount
	Inventory_ui.update_coin(Coins)
func add_trash(Amount: int):
	Trash += Amount
	Inventory_ui.update_trash(Trash)

#-----for item methods-----#
# Reset the status of an Inventory Slot and Selected
func _reset_item_slot(Slot: int) -> void:
	Inventory_slots[Slot].reset()
	Selected = -1

# Get item from inventory array
func get_item(Index):
	if Index >= 0 and Index < Inventory_slot_num:
		return Items[Index]
	return null

# Add an item to the inventory
func add_item(Item_data: Node2D) -> bool:
	var Item_parent = Item_data.get_parent()
	if Item_parent:  # Check if the item has a parent
		Item_parent.remove_child(Item_data)  # Remove it first

	for I in range(Inventory_slot_num):
		if Items[I] == null:  # Find empty slot in the Inventory
			Items[I] = Item_data
			print("Added:", Item_data["name"])
			Item_data.Exist_in = Existence.INVENTORY  # Update state
			Inventory_slots[I].toggle_item() # Lets Item Slot know it has an item
			Inventory_ui.update_inventory() # InventoryUI update (child)
			
			# Apply effect of item
			if Item_data:
				Item_data.apply_effect(Player)
				
			return true  # Item added successfully

	print("Inventory Full!")
	Item_parent.add_child(Item_data)
	return false  # No space available

# Whenever an item Slot is clicked.
func _on_item_slot_clicked(Index: int) -> void:
	await get_tree().create_timer(0.001).timeout # Timeout to avoid bugs
	# reset if invalid Index or same as Selected
	if Index < 0 or Index >= Inventory_slot_num or Selected == Index:
		print("Invalid inventory index:", Index)
		_reset_item_slot(Selected)
		return
	# If no selected and Index has Item, Select
	elif Selected == -1 and Items[Index]:
		Selected = Index
	# If valid index and already selected, Move items
	if Selected != -1:
		move_item(Index)


# Drop an item into the world
func drop_item():
	if Selected == -1:
		print("No Selected Item:", Selected)
		return
	# Retrieve the item node from the inventory array
	var Item_instance = Items[Selected]
	if not Item_instance:
		print("No item at index:", Selected)
		return
	Items[Selected] = null  # Remove from inventory
	
	 # Get current game world and move to world
	var World_scene = Player.get_parent()
	World_scene.add_child(Item_instance)
	
	# Change Item Statuses
	Item_instance.Exist_in = Existence.WORLD  # Update state
	Item_instance.global_position = Player.global_position
	Item_instance.visible = true  # Ensure it's visible in the world
	
	# Change Item Slot statuses
	Inventory_slots[Selected].toggle_item()
	_reset_item_slot(Selected)
	
	# Remove effect of item
	if Item_instance:
		Item_instance.remove_effect(Player)

	# Update visuals
	Inventory_ui.update_inventory() # InventoryUI (child)

# Move an item from one item slot to another
# or switch with another item location
func move_item(Index: int) -> void:
	if Selected == Index:
		return

	# Swap Selected and Index
	var holder = Items[Selected]
	if Items[Index] != null:
		Items[Selected] = Items[Index]
	else:
		Items[Selected] = null
		# Change Item Slot statuses
		Inventory_slots[Selected].toggle_item()
		Inventory_slots[Index].toggle_item()
	Items[Index] = holder
	
	# Change Item Slot statuses and Selected
	_reset_item_slot(Selected)
	_reset_item_slot(Index)

	# Update UI after move/swap
	Inventory_ui.update_inventory()

	

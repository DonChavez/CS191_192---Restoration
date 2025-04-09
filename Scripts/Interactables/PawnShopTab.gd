extends Control

#-----onready variables-----#
@onready var Description = $InventoryUI/InventoryPanel/ScrollDescription/Description
@onready var Inventory_ui = $InventoryUI
@onready var Inventory_slots = $InventoryUI/InventoryPanel/ScrollContainer/CenterContainer/InventoryGrid.get_children() # Slots
@onready var Inventory_slot_num: int = Inventory_slots.size() # number of slots
@onready var Player: CharacterBody2D
@onready var Inventory: InventoryObject
@onready var Owner: CharacterBody2D


# Inventory Configuration
@onready var Items: Array = []
@onready var Selected: int = -1
@onready var Range_items: int = 0
@onready var Melee_items: int = 0

var Item_cost_convertion: Dictionary = {	0: 2,
									1: 4,
									2: 8,
									3: 14,
									4: 24}

enum Existence { WORLD, INVENTORY, SHOP}
enum ItemType {RANGE, MELEE, PASSIVE}


# Called when the node enters the scene tree for the first time.
func _ready():	# Empty inventory at the start (Change)
	for I in range(Inventory_slot_num):
		Items.append(null)  # Empty slot
		Inventory_slots[I].set_index(I) # Sets the index of each slot (item_slot)
	Inventory_ui.update_inventory() # InventoryUI updates UI (child)
	self.visible = false

func _process(delta: float) -> void:
	if self.visible and Input.is_action_just_pressed("block"):
		_reset_item_slot(Selected)
		Inventory_ui.update_inventory() # InventoryUI update (child)


# Toggle to see or not the Inventory UI
func toggle_tab():
	self.visible = !self.visible
	if self.visible:
		Inventory_ui.update_coin(Inventory.Coins)
		Items = Inventory.get_inventory_array().duplicate()
		for I in range(Inventory_slot_num):
			if Items[I]:
				Inventory_slots[I].toggle_item(true) # Lets Item Slot know it has an item
			else:
				Inventory_slots[I].toggle_item(false) # Lets Item Slot know it has an item

		Inventory_ui.update_inventory()
	_reset_item_slot(Selected)
	Inventory.reset_item_slot(Selected)
	Inventory.disable_toggle()
		

func send_player(Player_body: CharacterBody2D):
	Player = Player_body
	Inventory = Player.get_inventory()

func send_owner(Owner_body: CharacterBody2D):
	Owner = Owner_body


#-----for item methods-----#
# Reset the status of an Inventory Slot and Selected
func _reset_item_slot(Slot: int) -> void:
	Inventory_slots[Slot].reset()
	Selected = -1
	Description.text = ""
	print("reset")

# Get item from inventory array
func get_item(Index):
	if Index >= 0 and Index < Inventory_slot_num:
		return Items[Index]
	return null


# Whenever an item Slot is clicked.
func _on_item_slot_clicked(Index: int) -> void:
	
	Inventory.on_item_slot_clicked(Index)
	await get_tree().create_timer(0.001).timeout # Timeout to avoid bugs
	# reset if invalid Index or same as Selected
	if Index < 0 or Index >= Inventory_slot_num or Selected == Index:
		print("Invalid inventory index:", Index)
		_reset_item_slot(Selected)
		return
	# If no selected and Index has Item, Select
	elif Selected == -1 and Items[Index]:
		print("Selected: ", Index)
		Selected = Index
		get_description()
	# If valid index and already selected, Move items
	if Selected != -1:
		move_item(Index)

# Drop an item into the world
func sell_item() -> void:
	if Selected == -1:
		print("No Selected Item:", Selected)
		return
	# Retrieve the item node from the inventory array
	var Item_instance = Items[Selected]
	if not Item_instance:
		print("No item at index:", Selected)
		return
	print("Now Null")
	Items[Selected] = null  # Remove from inventory
	
	var Profit = Item_cost_convertion[Item_instance.get_item_tier()]
	Inventory.add_coin(Profit)
	Inventory_ui.update_coin(Inventory.Coins)

	print("Finished Profit")
	# Change Item Slot statuses
	Inventory_slots[Selected].toggle_item(false)
	print("Deleting")
	Inventory.delete_item(Selected)
	_reset_item_slot(Selected)

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
	Items[Index] = holder
	Inventory_slots[Selected].toggle_item(true)
	Inventory_slots[Index].toggle_item(true)
	# Change Item Slot statuses and Selected
	_reset_item_slot(Selected)
	_reset_item_slot(Index)
	# Update UI after move/swap
	Inventory_ui.update_inventory()
	
func get_description() -> void:  
	var Item = Items[Selected]
	Description.text = Item.Title +" ("+ str(Item_cost_convertion[Item.get_item_tier()]) + " Gold)"+"\n" + Item.Description

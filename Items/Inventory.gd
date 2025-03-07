extends Node2D
class_name InventoryObject

@onready var Inventory_ui = $InventoryUI

const Inventory_slots = 32 # Inventory cap
var Items: Array = []
var Coins: int = 0
var Trash: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():	# Empty inventory at the start (Change)
	for I in range(Inventory_slots):
		Items.append(null)  # Empty slot
	Inventory_ui.update_inventory() # InventoryUI (sibling)
	Inventory_ui.visible=false
	
func _process(Delta: float) -> void:
	if Input.is_action_just_pressed("inventory"):
		toggle_inventory()

func toggle_inventory():	# InventoryUI (sibling)
	Inventory_ui.visible = !Inventory_ui.visible

func add_coin():
	Coins += 1
	Inventory_ui.update_coin(Coins)
func add_trash(Amount: int):
	Trash += Amount
	Inventory_ui.update_trash(Trash)

# Remove an item
func remove_item(Index):
	if Index >= 0 and Index < Inventory_slots:
		print("Removed:", Items[Index])
		Items[Index] = null  # Remove the item
		Inventory_ui.update_inventory() # InventoryUI (sibling)

# Add an item to the inventory
func add_item(Item_data):
	for I in range(Inventory_slots):
		if Items[I] == null:  # Find empty slot
			Items[I] = Item_data
			print("Added:", Item_data["name"])
			Inventory_ui.update_inventory() # InventoryUI (sibling)
			return true  # Item added successfully
	print("Inventory Full!")
	return false  # No space available
	
# Get item from inventory
func get_item(Index):
	if Index >= 0 and Index < Inventory_slots:
		return Items[Index]
	return null

extends Control
# class_name allows us to inherit functions/values in to or from other nodes
class_name InventoryObject

#-----onready variables-----#
@onready var Description = $InventoryUI/InventoryPanel/ScrollDescription/Description
@onready var Inventory_ui = $InventoryUI
@onready var Inventory_slots = $InventoryUI/InventoryPanel/ScrollContainer/CenterContainer/InventoryGrid.get_children() # Slots
@onready var Inventory_slot_num: int = Inventory_slots.size() # number of slots
@onready var Player: CharacterBody2D = get_parent().get_parent()

# Inventory Configuration
@onready var Items: Array = []
@onready var Coins: int = 0
@onready var Trash: int = 0
@onready var Selected: int = -1
@onready var Range_items: int = 0
@onready var Melee_items: int = 0
@onready var Disable: bool = false


enum Existence { WORLD, INVENTORY, SHOP}
enum ItemType {RANGE, MELEE, PASSIVE}

# Called when the node enters the scene tree for the first time.
func _ready():	# Empty inventory at the start (Change)
	for I in range(Inventory_slot_num):
		Items.append(null)  # Empty slot
		Inventory_slots[I].set_index(I) # Sets the index of each slot (item_slot)
	Inventory_ui.update_inventory() # InventoryUI updates UI (child)
	self.visible = false

func _process(Delta: float) -> void:
	if not Disable:
		if Input.is_action_just_pressed("inventory"):
			toggle_inventory()
			reset_item_slot(Selected)
			Inventory_ui.update_inventory() # InventoryUI update (child)
			Player.Can_process_input = !Player.Can_process_input
		if Input.is_action_just_pressed("block"):
			reset_item_slot(Selected)
			Inventory_ui.update_inventory() # InventoryUI update (child)

# Toggle to see or not the Inventory UI
func toggle_inventory():
	self.visible = !self.visible
func disable_toggle() -> void:
	Disable = !Disable

# Updates collectible amounts
func add_coin(Amount: int):
	Coins += Amount
	Inventory_ui.update_coin(Coins)
func add_trash(Amount: int):
	Trash += Amount
	Inventory_ui.update_trash(Trash)

#-----for getting values methods-----#
func get_description() -> void:
	Description.text = Items[Selected].Title +"\n" + Items[Selected].Description

func get_inventory_array() -> Array:
	return Items

# Get item from inventory array
func get_item(Index):
	if Index >= 0 and Index < Inventory_slot_num:
		return Items[Index]
	return null

#-----for item methods-----#
# Reset the status of an Inventory Slot and Selected
func reset_item_slot(Slot: int) -> void:
	Inventory_slots[Slot].reset()
	Selected = -1
	Description.text = ""

func add_item_type(Item: ItemObject) -> void:
	if Item.Item_type == ItemType.RANGE:
		Range_items += 1
		Player.get_range(Range_items)
	elif Item.Item_type == ItemType.MELEE:
		Melee_items += 1	
		Player.get_melee(Melee_items)
func remove_item_type(Item: ItemObject) -> void:
	if Item.Item_type == ItemType.RANGE:
		Range_items -= 1
	elif Item.Item_type == ItemType.MELEE:
		Melee_items -= 1	
# Add an item to the inventory
func add_item(Item_data: Node2D) -> bool:
	var Item_parent = Item_data.get_parent()
	if Item_parent:  # Check if the item has a parent
		Item_parent.remove_child(Item_data)  # Remove it first

	for I in range(Inventory_slot_num):
		if Items[I] == null:  # Find empty slot in the Inventory
			
			# Apply effect of item
			apply_item_effect(Item_data)

			add_item_type(Item_data)
			Items[I] = Item_data
			print("Added:", Item_data["name"])
			Item_data.Exist_in = Existence.INVENTORY  # Update state
			Inventory_slots[I].toggle_item(Item_data) # Lets Item Slot know it has an item
			Inventory_ui.update_inventory() # InventoryUI update (child)
				
			return true  # Item added successfully

	print("Inventory Full!")
	Item_parent.add_child(Item_data)
	return false  # No space available

# Whenever an item Slot is clicked.
func on_item_slot_clicked(Index: int) -> void:
	await get_tree().create_timer(0.001).timeout # Timeout to avoid bugs
	# reset if invalid Index or same as Selected
	if Index < 0 or Index >= Inventory_slot_num or Selected == Index:
		print("Invalid inventory index:", Index)
		reset_item_slot(Selected)
		return
	# If no selected and Index has Item, Select
	elif Selected == -1 and Items[Index]:
		Selected = Index
		get_description()
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
	Inventory_slots[Selected].toggle_item(null)
	reset_item_slot(Selected)
	remove_item_type(Item_instance)
	Player.get_range(Range_items)
	Player.get_melee(Melee_items)
	# Remove effect of item
	if Item_instance.get_stacking():
		Item_instance.remove_effect(Player)
	else:
		reapply_removed_item_effect(Item_instance)


	# Update visuals
	Inventory_ui.update_inventory() # InventoryUI (child)

func delete_item(Index: int) -> void:
	# Retrieve the item node from the inventory array
	var Item_instance = Items[Index]
	if not Item_instance:
		print("No item at index:", Selected)
		return
	Items[Selected] = null  # Remove from inventory
	
	# Change Item Slot statuses
	Inventory_slots[Selected].toggle_item(null)
	reset_item_slot(Selected)
	remove_item_type(Item_instance)
	Player.get_range(Range_items)
	Player.get_melee(Melee_items)
	# Remove effect of item
	if Item_instance.get_stacking():
		Item_instance.remove_effect(Player)
	else:
		reapply_removed_item_effect(Item_instance)
	
	Item_instance.queue_free()
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
	Items[Index] = holder
	Inventory_slots[Selected].toggle_item(Items[Selected])
	Inventory_slots[Index].toggle_item(Items[Index])
	# Change Item Slot statuses and Selected
	reset_item_slot(Selected)
	reset_item_slot(Index)
	# Update UI after move/swap
	Inventory_ui.update_inventory()

func apply_item_effect(New_item: Node2D) -> void:
	if not New_item.get_stacking():
		var New_item_id = New_item.get_item_id().substr(1)
		var New_item_tier = New_item.get_item_tier()
		for Item in Items:
			if Item:
				if Item.get_item_id().substr(1) == New_item_id and Item.get_applied():
					if Item.get_item_tier() < New_item_tier:
						Item.remove_effect(Player)
						New_item.apply_effect(Player)
						print("removed")
						return
					else:
						return
		# Loop removes the current tier that is working to apply only better tier
	New_item.apply_effect(Player)

func reapply_removed_item_effect(Removed_item:Node2D) -> void:
	# If not applied, meaning lower tier, no need to do anything
	if not Removed_item.get_applied():	
		return

	var Removed_id = Removed_item.get_item_id().substr(1)	# Removes Item Tier and checks only ID
	var Removed_tier = Removed_item.get_item_tier()		# Checks Item Tier
	var Replacement_item = null
	for Item in Items:
		if Item:
			if not Item.get_applied() and Item.get_item_id().substr(1) == Removed_id:
				if not Replacement_item:
					Replacement_item = Item
				if Item.get_item_tier() > Removed_tier:
					Replacement_item = Item
	# loop finds best item tier of the same type as removed item and applies it
	# Remove item of current item
	Removed_item.remove_effect(Player)
	if Replacement_item:	# Apply replacement item if it exists
		Replacement_item.apply_effect(Player)

func update_items() -> void:
	for Item in Items:
		if Item:
			Item.update_item_status()

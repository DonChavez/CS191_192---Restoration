extends Control

@onready var Inventory_manager = $".."
@onready var Grid = $InventoryPanel/ScrollContainer/CenterContainer/InventoryGrid.get_children()
@onready var Trashlabel = $InventoryPanel/TrashLabel if is_instance_valid($InventoryPanel/TrashLabel) else null
@onready var Coinlabel = $InventoryPanel/CoinLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Update texture of each Slot
func update_inventory():
	for I in range(Grid.size()):
		var Item = Inventory_manager.get_item(I) #InventorManager get item
		var Slot = Grid[I]  # Get slot node
		
		# Replace with Icon texture if has item
		if Item:
			Slot.texture_normal = Item.get_node("Icon").texture
			Slot.update_slot_ui()
		else: 
			Slot.texture_normal = load("res://Art/tilesets/grid.png") #Blank tile
			Slot.update_slot_ui()
		
		
# Update Coin count UI
func update_trash(Trash:int):
	Trashlabel.text = str(Trash)

# Update Trash count UI
func update_coin(Coin:int):
	Coinlabel.text = str(Coin)

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
		
		Slot.texture_normal = load("res://Art/tilesets/grid.png")
		if Item:
			Slot.toggle_item_ui(Item.get_node("Icon").texture)
		else:
			Slot.toggle_item_ui(null)
		
		
# Update Coin count UI
func update_trash(Trash:int):
	Trashlabel.text = str(Trash)

# Update Trash count UI
func update_coin(Coin:int):
	Coinlabel.text = str(Coin)

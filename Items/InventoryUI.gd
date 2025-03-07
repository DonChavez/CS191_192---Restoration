extends Control

@onready var Inventory_manager = $".."
@onready var Grid = $InventoryPanel/ScrollContainer/CenterContainer/InventoryGrid.get_children()
@onready var Trashlabel = $InventoryPanel/TrashLabel
@onready var Coinlabel = $InventoryPanel/CoinLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func update_inventory():
	for I in range(Grid.size()):
		var Item = Inventory_manager.get_item(I)
		var Slot = Grid[I]  # Get slot node
		Slot.texture = load("res://Art/tilesets/grid.png")

		if Item:
			var sprite_node = Item.get_node_or_null("AnimatedSprite2D")  # Try to get the child node safely
			if sprite_node:
				var texture = sprite_node.sprite_frames.get_frame_texture(sprite_node.animation, sprite_node.frame)
				Slot.texture = texture  # Show item icon

func update_trash(Trash:int):
		Trashlabel.text = str(Trash)
func update_coin(Coin:int):
		Coinlabel.text = str(Coin)

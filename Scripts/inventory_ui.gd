extends Control

@onready var Inventory_manager = $".."
@onready var Grid = %InventoryGrid.get_children()
@onready var Trashlabel = $InventoryPanel/TrashLabel
@onready var Coinlabel = $InventoryPanel/CoinLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(Delta: float) -> void:
	if Input.is_action_just_pressed("inventory"):
		toggle_inventory()

#Toggle to see or not the Inventory UI
func toggle_inventory():
	self.visible = !self.visible

# Update texture of each Slot
func update_inventory():
	for I in range(Grid.size()):
		var Item = Inventory_manager.get_item(I) #InventorManager get item
		var Slot = Grid[I]  # Get slot node

		if Item:
			var Sprite_node = Item.get_node_or_null("AnimatedSprite2D")  # Try to get the child node safely
			if Sprite_node:
				var Textured = Sprite_node.sprite_frames.get_frame_texture(Sprite_node.animation, Sprite_node.frame)
				Slot.texture = Textured  # Show item icon
		else: 
			Slot.texture = load("res://Art/tilesets/grid.png") #Blank tile

# Update Coin count UI
func update_trash(Trash:int):
	Trashlabel.text = str(Trash)

# Update Trash count UI
func update_coin(Coin:int):
	Coinlabel.text = str(Coin)

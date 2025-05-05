extends Node2D

#-----onready variables-----#
@onready var Input_label = $InputLabel
@onready var RecyclerUI = $RecyclerUI
@onready var Recycler_slots = $RecyclerUI/RecyclerPanel/ScrollContainer/RecycleGrid.get_children() #Slots
@onready var Item_manager = $ItemManager
@onready var Selected: int = -1


#-----local variables-----#
@onready var Player: CharacterBody2D = null  
@onready var Inventory: InventoryObject = null
#-----Index Mapping Dictionaries-----#

var Item_category_map = {	# Temp printing
	0: "Common Item",
	1: "Uncommon Item",
	2: "Rare Item",
	3: "Epic Item",
	4: "Legendary Item"
}
# Cost mapping
var Item_cost_map = {
	0: 5,
	1: 10,
	2: 20,
	3: 35,
	4: 60
}

# music variable
@onready var Recycler_sfx: AudioStreamPlayer2D = $AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for I in range(Recycler_slots.size()):
		Recycler_slots[I].set_index(I) 

	
	RecyclerUI.add_labels(Item_cost_map)
	Input_label.visible = false
	RecyclerUI.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	# Remove if interacted with
	if Input_label.visible and Input.is_action_just_pressed("interact"):
		RecyclerUI.toggle_recycler()
		Selected = -1
		RecyclerUI.update_trash(Inventory.Trash)

# Interact button appears
func _on_area_2d_body_entered(Body: Node2D) -> void:
	Input_label.visible = true
	Player = Body
	Inventory = Player.get_inventory()
	PlayerManager.disable_player_input()

# Interact button disappears
func _on_area_2d_body_exited(Body: Node2D) -> void:
	Input_label.visible = false
	RecyclerUI.visible = false
	Selected = -1
	PlayerManager.enable_player_input()

# drop/spawn an item in world
func _drop_item(Item_instance: Node2D):
	
	Item_instance.global_position = self.global_position+Vector2(0,70)
	Item_instance.visible = true  # Ensure it's visible in the world
	Item_instance.Spawn_animate = true # allows the items to jump out of existence

	var World_scene = get_tree().current_scene  # Get current game world
	World_scene.add_child(Item_instance)  # Move to world

# Get random item depending on which button clicked
func _on_recycler_button_clicked(Index: int) -> void:
	if Selected != Index:
		Selected = Index
		RecyclerUI.add_description(Index)
		#text
	else:
		var Item: Node2D
		var Cost: int = Item_cost_map[Index]
		# Get Item, Subtract Inventory trash, Update RecyclerUI
		if Inventory.Trash >= Cost:
			Item = Item_manager.get_random_item(Index)
			print(Item_category_map[Index])
			Inventory.add_trash(-Cost)
			RecyclerUI.update_trash(Inventory.Trash)
			_drop_item(Item) # self method
			Recycler_sfx.play()
		else:
			print("Not enough trash")

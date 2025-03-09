extends Node

"""
Dictionary mapping item IDs to their scenes
Items starting with 1 are common, 2 are uncommon, 3 are rare, 
4 are epic, and 5 are legendary
"""
const Item_database = {
	"00001": preload("res://Scenes/Items/C001.tscn"),
	"00002": preload("res://Scenes/Items/C002.tscn"),
	"10001": preload("res://Scenes/Items/U001.tscn"),
	"10002": preload("res://Scenes/Items/U002.tscn"),
	"20001": preload("res://Scenes/Items/R001.tscn"),
	"20002": preload("res://Scenes/Items/R002.tscn"),
	"30001": preload("res://Scenes/Items/E001.tscn"),
	"30002": preload("res://Scenes/Items/E002.tscn"),
	"40001": preload("res://Scenes/Items/L001.tscn"),
	"40002": preload("res://Scenes/Items/L002.tscn"),

}

# Function to get an item scene by ID
func get_item_scene(Item_id: String) -> PackedScene:
	return Item_database.get(Item_id, null)  # Returns null if item ID doesn't exist

# Function to spawn an item in the world (Redundant for now)
func spawn_item(Item_id: String, Position: Vector2) -> Node2D:
	var Item_scene = get_item_scene(Item_id)
	if Item_scene:
		var Item_instance = Item_scene.instantiate()
		get_tree().current_scene.add_child(Item_instance)
		Item_instance.global_position = Position
		return Item_instance  # Optional: return reference to spawned item
	return null

# Filters the Item_database keys with numeric values
func filter_keys_by_key_range(Start_key: int, End_key: int) -> Array:
	var Valid_keys = []

	for Key in Item_database.keys(): # Goes through all keys
		var Int_key = int(Key)  
		if Int_key >= Start_key and Int_key <= End_key:
			Valid_keys.append(Key)  # Add the key to the valid keys array

	return Valid_keys

# Get a random item given a Tier
func get_random_item(Tier: int) -> Node2D:
	var Filtered: Array

	# Filtering based on the tier
	match Tier:
		0:
			Filtered = filter_keys_by_key_range(0, 9999)
		1:
			Filtered = filter_keys_by_key_range(10000, 19999)
		2:
			Filtered = filter_keys_by_key_range(20000, 29999)
		3:
			Filtered = filter_keys_by_key_range(30000, 39999)
		4:
			Filtered = filter_keys_by_key_range(40000, 49999)

	#Gets the item scene and creates an instance
	var Item_scene = get_item_scene(Filtered.pick_random())
	var Item_instance = Item_scene.instantiate()
	return Item_instance

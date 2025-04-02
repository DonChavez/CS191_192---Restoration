extends Node

"""
Dictionary mapping item IDs to their scenes
Items starting with - are common, 1 are uncommon, 2 are rare, 
3 are epic, and 4 are legendary
"""
const Item_database = {
	"0001": preload("res://Scenes/Items/0Richochet.tscn"),
	"1001": preload("res://Scenes/Items/0Richochet.tscn"),
	"2001": preload("res://Scenes/Items/0Richochet.tscn"),
	"3001": preload("res://Scenes/Items/0Richochet.tscn"),
	"4001": preload("res://Scenes/Items/0Richochet.tscn"),
	
	"1002": preload("res://Scenes/Items/0Pierce.tscn"),
	"2002": preload("res://Scenes/Items/0Pierce.tscn"),
	"3002": preload("res://Scenes/Items/0Pierce.tscn"),
	"4002": preload("res://Scenes/Items/0Pierce.tscn"),
	
	"2003": preload("res://Scenes/Items/0SpreadShot.tscn"),
	"3003": preload("res://Scenes/Items/0SpreadShot.tscn"),
	"4003": preload("res://Scenes/Items/0SpreadShot.tscn"),
	
	"2004": preload("res://Scenes/Items/0MultiShot.tscn"),
	"3004": preload("res://Scenes/Items/0MultiShot.tscn"),
	"4004": preload("res://Scenes/Items/0MultiShot.tscn"),
	
	"0005": preload("res://Scenes/Items/0ProjectileLife.tscn"),
	"1005": preload("res://Scenes/Items/0ProjectileLife.tscn"),
	"2005": preload("res://Scenes/Items/0ProjectileLife.tscn"),
	"3005": preload("res://Scenes/Items/0ProjectileLife.tscn"),
	"4005": preload("res://Scenes/Items/0ProjectileLife.tscn"),
	
	"0006": preload("res://Scenes/Items/0Spin.tscn"),
	"1006": preload("res://Scenes/Items/0Spin.tscn"),
	"2006": preload("res://Scenes/Items/0Spin.tscn"),
	"3006": preload("res://Scenes/Items/0Spin.tscn"),
	"4006": preload("res://Scenes/Items/0Spin.tscn")
	
#	"006": preload(),
#	"007": preload(),

}

# Function to get an item scene by ID
func get_item_scene(Item_id: String) -> PackedScene:
	return Item_database.get(Item_id, null)  # Returns null if item ID doesn't exist

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
	var ID_array: Array
	var Filtered: Array

	# Filtering based on the tier
	match Tier:
		0:
			Filtered = filter_keys_by_key_range(0, 999)
		1:
			Filtered = filter_keys_by_key_range(1000, 1999)
		2:
			Filtered = filter_keys_by_key_range(2000, 2999)
		3:
			Filtered = filter_keys_by_key_range(3000, 3999)
		4:
			Filtered = filter_keys_by_key_range(4000, 4999)

	#Gets the item scene and creates an instance
	var Tiered_item_id: String = Filtered.pick_random()

	#Gets the item scene and creates an instance
	var Item_scene: PackedScene = get_item_scene(Tiered_item_id)
	var Item_instance: Node2D = Item_scene.instantiate()

	Item_instance.change_ID(Tiered_item_id)
	return Item_instance

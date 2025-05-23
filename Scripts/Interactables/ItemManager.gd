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
	
#	"0005": preload("res://Scenes/Items/0ProjectileLife.tscn"),
#	"1005": preload("res://Scenes/Items/0ProjectileLife.tscn"),
#	"2005": preload("res://Scenes/Items/0ProjectileLife.tscn"),
#	"3005": preload("res://Scenes/Items/0ProjectileLife.tscn"),
#	"4005": preload("res://Scenes/Items/0ProjectileLife.tscn"),
	
	"0006": preload("res://Scenes/Items/0SwordSpin.tscn"),
	"1006": preload("res://Scenes/Items/0SwordSpin.tscn"),
	"2006": preload("res://Scenes/Items/0SwordSpin.tscn"),
	"3006": preload("res://Scenes/Items/0SwordSpin.tscn"),
	"4006": preload("res://Scenes/Items/0SwordSpin.tscn"),
	
	"0007": preload("res://Scenes/Items/0SwordHate.tscn"),
	"1007": preload("res://Scenes/Items/0SwordHate.tscn"),
	"2007": preload("res://Scenes/Items/0SwordHate.tscn"),
	"3007": preload("res://Scenes/Items/0SwordHate.tscn"),
	"4007": preload("res://Scenes/Items/0SwordHate.tscn"),
	
	"0008": preload("res://Scenes/Items/0SwordLeech.tscn"),
	"1008": preload("res://Scenes/Items/0SwordLeech.tscn"),
	"2008": preload("res://Scenes/Items/0SwordLeech.tscn"),
	"3008": preload("res://Scenes/Items/0SwordLeech.tscn"),
	"4008": preload("res://Scenes/Items/0SwordLeech.tscn"),
	
	"0009": preload("res://Scenes/Items/0StoneSkin.tscn"),
	"1009": preload("res://Scenes/Items/0StoneSkin.tscn"),
	"2009": preload("res://Scenes/Items/0StoneSkin.tscn"),
	"3009": preload("res://Scenes/Items/0StoneSkin.tscn"),
	"4009": preload("res://Scenes/Items/0StoneSkin.tscn"),

	"0010": preload("res://Scenes/Items/0DoubleTime.tscn"),
	"1010": preload("res://Scenes/Items/0DoubleTime.tscn"),
	"2010": preload("res://Scenes/Items/0DoubleTime.tscn"),
	"3010": preload("res://Scenes/Items/0DoubleTime.tscn"),
	"4010": preload("res://Scenes/Items/0DoubleTime.tscn"),
	
	"2011": preload("res://Scenes/Items/0GlassCannon.tscn"),
	"3011": preload("res://Scenes/Items/0GlassCannon.tscn"),
	"4011": preload("res://Scenes/Items/0GlassCannon.tscn"),
	
	"2012": preload("res://Scenes/Items/0DashBoots.tscn"),
	"3012": preload("res://Scenes/Items/0DashBoots.tscn"),
	"4012": preload("res://Scenes/Items/0DashBoots.tscn"),
	
	"3013": preload("res://Scenes/Items/0FireTank.tscn"),
	"4013": preload("res://Scenes/Items/0FireTank.tscn"),
	
	"0014": preload("res://Scenes/Items/0LifeCrystal.tscn"),
	"1014": preload("res://Scenes/Items/0LifeCrystal.tscn"),
	"2014": preload("res://Scenes/Items/0LifeCrystal.tscn"),
	"3014": preload("res://Scenes/Items/0LifeCrystal.tscn"),
	"4014": preload("res://Scenes/Items/0LifeCrystal.tscn"),
	
	"0015": preload("res://Scenes/Items/0SwordLight.tscn"),
	"1015": preload("res://Scenes/Items/0SwordLight.tscn"),
	"2015": preload("res://Scenes/Items/0SwordLight.tscn"),
	"3015": preload("res://Scenes/Items/0SwordLight.tscn"),
	"4015": preload("res://Scenes/Items/0SwordLight.tscn"),
	
	"0016": preload("res://Scenes/Items/0ParryMantle.tscn"),
	"1016": preload("res://Scenes/Items/0ParryMantle.tscn"),
	"2016": preload("res://Scenes/Items/0ParryMantle.tscn"),
	"3016": preload("res://Scenes/Items/0ParryMantle.tscn"),
	"4016": preload("res://Scenes/Items/0ParryMantle.tscn"),
	
	"0017": preload("res://Scenes/Items/0RiposteGauntlet.tscn"),
	"1017": preload("res://Scenes/Items/0RiposteGauntlet.tscn"),
	"2017": preload("res://Scenes/Items/0RiposteGauntlet.tscn"),
	"3017": preload("res://Scenes/Items/0RiposteGauntlet.tscn"),
	"4017": preload("res://Scenes/Items/0RiposteGauntlet.tscn"),
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

	#Gets the item ID
	var Tiered_item_id: String = Filtered.pick_random()

	#Gets the item scene and creates an instance
	var Item_scene: PackedScene = get_item_scene(Tiered_item_id)
	var Item_instance: Node2D = Item_scene.instantiate()

	Item_instance.change_ID(Tiered_item_id)
	return Item_instance

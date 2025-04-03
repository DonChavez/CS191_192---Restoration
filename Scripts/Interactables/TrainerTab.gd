extends Control

#-----onready variables-----#
@onready var UpgradeUI = $UpgradePanel
@onready var Upgrade_slots = $UpgradePanel/ScrollContainer/UpgradeGrid.get_children() #Slots
@onready var Selected: int = -1

#-----local variables-----#
@onready var Player: CharacterBody2D = null  
@onready var Inventory: InventoryObject = null

# Costs when upgrading stats
const Upgrade_cost_map = {
	0: 1,
	1: 5,
	2: 10,
	3: 20,
	4: 50,
	5: -1
}
var Index_stat_map = {
	0: "Health",
	1: "Melee",
	2: "Range",
	3: "Attack Speed",
	4: "Speed"
}

var stat_upgrade_map = {
	"Health":20,
	"Melee":10,
	"Range":5,
	"Attack Speed":0.3,
	"Speed":15
}

# Player stats and the number of times they been upgraded Copy for costs
@onready var Player_upgrade_counter: Dictionary


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for I in range(Upgrade_slots.size()):
		Upgrade_slots[I].set_index(I) 

	# Edit Slot labels
	

	self.visible = false

# Send Player, inventory, and Dictionary reference, done by Owner
func send_player(Player_body: CharacterBody2D):
	Player = Player_body
	Inventory = Player.get_inventory()
	Player_upgrade_counter = Player.get_upgrade_counter()
	UpgradeUI.send_dictionaries(Index_stat_map, Upgrade_cost_map)
	UpgradeUI.add_labels(Player_upgrade_counter)

# Toggle visible of the Tab
func toggle_tab() -> void:
	self.visible = !self.visible
	UpgradeUI.update_coin(Inventory.Coins)
	Selected = -1

# Upon clicking on button, upgrade corresponding stat
func _on_upgrade_button_clicked(Index: int) -> void:
	if Selected != Index:
		Selected = Index
		UpgradeUI.add_description(Index,stat_upgrade_map[Index_stat_map[Index]])
	else:
		# Cost mapping
		var Stat_name = Index_stat_map[Index]
		var Player_curr_upgrade: int =  Player.get_curr_upgrade(Stat_name)
		var Cost: int = Upgrade_cost_map[Player_curr_upgrade]
		
		# if max
		if Cost == -1:
			print('max')
			return
		# If possible
		if Inventory.Coins >= Cost:
			print(Stat_name)
			Inventory.add_coin(-Cost)
			UpgradeUI.update_coin(Inventory.Coins)
			
			upgrade_stat(Stat_name)	# Upgrade stat
			
			Player.add_curr_upgrade(Stat_name)	# Increase the upgrade count
			UpgradeUI.add_labels(Player_upgrade_counter)
			UpgradeUI.add_description(Index, stat_upgrade_map[Index_stat_map[Index]])
		else:
			print("Not enough coin")
		
# ------ Upgrades
func upgrade_stat(Stat_name: String) -> void:
	var Value = stat_upgrade_map[Stat_name]
	match Stat_name:
		"Health":
			Player.new_base_attributes(Value, "Max Health")
		"Melee":
			Player.new_base_attributes(Value, "Melee Damage")
		"Range":
			Player.new_base_attributes(Value, "Projectile Damage")
		"Attack Speed":
			Player.new_base_attributes(Value, "Attack Speed")		
		"Speed":
			Player.new_base_attributes(Value, "Movement Speed")
			

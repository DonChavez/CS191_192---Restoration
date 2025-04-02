extends Control

#-----onready variables-----#
@onready var UpgradeUI = $UpgradePanel
@onready var Upgrade_slots = $UpgradePanel/ScrollContainer/UpgradeGrid.get_children() #Slots

#-----local variables-----#
@onready var Player: CharacterBody2D = null  
@onready var Inventory: InventoryObject = null

# Costs when upgrading stats
@onready var Upgrade_cost_map = {
	0: 1,
	1: 5,
	2: 10,
	3: 20,
	4: 50,
	5: -1
}
var Item_category_map = {	# ID Index mapping to text
	0: "Upgrade Health",
	1: "Upgrade Melee",
	2: "Upgrade Range",
	3: "Upgrade Attack Speed",
	4: "Upgrade Speed"
}
# Player stats and the number of times they been upgraded Copy for costs
@onready var Player_upgrade_cost: Dictionary


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for I in range(Upgrade_slots.size()):
		Upgrade_slots[I].set_index(I) 

	# Edit Slot labels
	UpgradeUI.get_labels(["Upgrade Health", "Upgrade Melee", "Upgrade Range", "Upgrade Attack Speed", "Upgrade Speed"])

	self.visible = false

# Send Player, inventory, and Dictionary reference, done by Owner
func send_player(Player_body: CharacterBody2D):
	Player = Player_body
	Inventory = Player.get_inventory()
	Player_upgrade_cost = Player.get_upgrade_counter()
	get_upgrade_costs()

# Toggle visible of the Tab
func toggle_tab() -> void:
	self.visible = !self.visible
	UpgradeUI.update_coin(Inventory.Coins)

# Updates the UI costs for all the statuses
func get_upgrade_costs() -> void:
	var Current_stats: int
	for I in range(Upgrade_slots.size()):
		var Stat_name = Item_category_map[I]
		Current_stats = Player_upgrade_cost[Stat_name]
		UpgradeUI.update_cost(I, Upgrade_cost_map[Current_stats])


# Upon clicking on button, upgrade corresponding stat
func _on_upgrade_button_clicked(Index: int) -> void:
	
	# Cost mapping
	var Stat_name = Item_category_map[Index]
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
		get_upgrade_costs()	# UI refresh
	else:
		print("Not enough coin")
		
# ------ Upgrades
func upgrade_stat(Stat_name: String) -> void:
	match Stat_name:
		"Upgrade Health":
			Player.new_base_attributes(20, "Health")
		"Upgrade Melee":
			Player.new_base_attributes(10, "Melee Damage")
		"Upgrade Range":
			Player.new_base_attributes(5, "Projectile Damage")
		"Upgrade Attack Speed":
			Player.new_base_attributes(0.3, "Attack Speed")		
		"Upgrade Speed":
			Player.new_base_attributes(15, "Movement Speed")
			

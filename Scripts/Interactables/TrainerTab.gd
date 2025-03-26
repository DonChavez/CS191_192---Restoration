extends Control

#-----onready variables-----#
@onready var UpgradeUI = $UpgradeUI
@onready var Upgrade_slots1 = $UpgradeUI/UpgradePanel/CenterContainer/UpgradeGrid.get_children() #Slots
@onready var Upgrade_slots2 = $UpgradeUI/UpgradePanel/CenterContainer2/UpgradeGrid2.get_children() #Slots

#-----local variables-----#
@onready var Player: CharacterBody2D = null  
@onready var Inventory: InventoryObject = null
@onready var Owner: CharacterBody2D

# Costs when upgrading stats
@onready var Upgrade_cost_map = {
		0: 1,
		1: 5,
		2: 10,
		3: 20,
		4: 50,
		5: -1
	}
# Player stats and the number of times they been upgraded
@onready var Player_upgrade_cost: Dictionary


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for I in range(Upgrade_slots1.size()):
		Upgrade_slots1[I].set_index(I) 
		Upgrade_slots1[I].set_id(0) 

	for I in range(Upgrade_slots2.size()):
		Upgrade_slots2[I].set_index(I) 
		Upgrade_slots2[I].set_id(1) 

	# Edit Slot labels
	UpgradeUI.get_labels(["Upgrade Health", "Upgrade Melee", "Upgrade Range", "Upgrade Attack Speed", "Upgrade Speed"])

	self.visible = false

# Send Player, inventory, and Dictionary reference, done by Owner
func send_player(Player_body: CharacterBody2D):
	Player = Player_body
	Inventory = Player.get_inventory()
	Player_upgrade_cost = Player.get_upgrade_counter()
	get_upgrade_costs()

# Owner Node
func send_owner(Owner_body: CharacterBody2D):
	Owner = Owner_body

# Toggle visible of the Tab
func toggle_tab() -> void:
	self.visible = !self.visible
	UpgradeUI.update_coin(Inventory.Coins)

# Updates the costs for all the statuses
func get_upgrade_costs() -> void:
	var Current_stats: int
	for I in range(Upgrade_slots1.size()):
		Current_stats = Player_upgrade_cost[0][I]
		UpgradeUI.get_cost(1, I, Upgrade_cost_map[Current_stats])

	for I in range(Upgrade_slots2.size()):
		Current_stats = Player_upgrade_cost[1][I]
		UpgradeUI.get_cost(2, I, Upgrade_cost_map[Current_stats])

# Upon clicking on button, upgrade corresponding stat
func _on_upgrade_button_clicked(Index: int, ID: int) -> void:
	var Item_category_map = {	# Temp printing
		0: {
			0: "Upgrade Health",
			1: "Upgrade Melee",
			2: "Upgrade Range"
		},
		1: {
			0: "Upgrade Attack Speed",
			1: "Upgrade Speed"
		}
	}
	# Cost mapping
	var Player_curr_upgrade: int =  Player.get_curr_upgrade(ID, Index)
	var Cost: int = Upgrade_cost_map[Player_curr_upgrade]
	
	# if max
	if Cost == -1:
		print('max')
		return
	# If possible
	if Inventory.Coins >= Cost:
		print("Upgraded ",Item_category_map[ID][Index])
		Inventory.add_coin(-Cost)
		UpgradeUI.update_coin(Inventory.Coins)
		
		upgrade_stat(Index,ID)	# Upgrade stat
		Player.add_curr_upgrade(ID, Index)	# Increase the upgrade count
		get_upgrade_costs()	# UI refresh
	else:
		print("Not enough coin")
		
# ------ Upgrades
func upgrade_stat(Index: int, ID: int) -> void:
	if Index == 0:
		if ID == 0:
			upgrade_health()
		elif ID == 1:
			upgrade_melee()
		elif ID == 2:
			upgrade_range()
	elif Index == 1:
		if ID == 0:
			upgrade_attack_speed()
		elif ID == 1:
			upgrade_speed()

func upgrade_health() -> void:
	Player.add_max_health(20)
func upgrade_melee() -> void:
	Player.add_melee_damage(10)
func upgrade_range() -> void:
	Player.add_projectile_damage(5)
func upgrade_attack_speed() -> void:
	Player.add_attack_speed(0.3)
func upgrade_speed() -> void:
	Player.add_movement_speed(15)

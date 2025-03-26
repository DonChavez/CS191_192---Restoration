extends Control

@onready var Grid1 = $UpgradePanel/CenterContainer/UpgradeGrid.get_children() #Slots
@onready var Grid2 = $UpgradePanel/CenterContainer2/UpgradeGrid2.get_children() #Slots
@onready var Coinlabel = $UpgradePanel/CoinLabel

var Builder: Array

# Add labels
func get_labels(Labels: Array) -> void:
	Builder = Labels.duplicate()
	for I in range(Grid1.size()):
		Grid1[I].change_label(Builder[I])
		Grid1[I].texture_normal = load("res://Art/tilesets/grid.png") #Blank tile
	for I in range(Grid2.size()):
		Grid2[I].change_label(Builder[I+3])
		Grid2[I].texture_normal = load("res://Art/tilesets/grid.png") #Blank tile

# Add costs for the correct Item slot
func get_cost(Grid_no: int, Index: int, Cost: int) -> void:
	if Grid_no == 1:
		if Cost == -1:
			Grid1[Index].maxed_out()
		else:
			Grid1[Index].change_cost(Cost)
	elif Grid_no == 2:
		if Cost == -1:
			Grid2[Index].maxed_out()
		else:
			Grid2[Index].change_cost(Cost)

# Updates the Coin amount
func update_coin(Coin:int):
	Coinlabel.text = str(Coin)

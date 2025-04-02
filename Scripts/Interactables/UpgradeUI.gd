extends Panel

@onready var Grid = $ScrollContainer/UpgradeGrid.get_children() #Slots
@onready var Coinlabel = $CoinLabel

var Builder: Array

# Add labels
func get_labels(Labels: Array) -> void:
	Builder = Labels.duplicate()
	for I in range(Grid.size()):
		Grid[I].change_label(Builder[I])
		Grid[I].texture_normal = load("res://Art/tilesets/grid.png") #Blank tile

# Add costs for the correct Item slot
func update_cost(Index: int, Cost: int) -> void:
	Grid[Index].change_cost(Cost)

# Updates the Coin amount
func update_coin(Coin:int):
	Coinlabel.text = str(Coin)

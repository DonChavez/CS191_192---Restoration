extends Panel

@onready var Grid:Array = $ScrollContainer/UpgradeGrid.get_children() #Slots
@onready var Coinlabel:Label = $CoinLabel
@onready var Description_box:RichTextLabel = $DescriptionTextLabel
var Item_category:Dictionary
var Player_upgrade_count:Dictionary
@onready var Costs:Dictionary 

const Number_to_roman1 = {	0:"I",
							1:"II",
							2:"III",
							3:"IV",
							4:"V",
							5:"MAX"	}
						

func send_dictionaries(Item_category_map:Dictionary, Cost:Dictionary):
	Item_category = Item_category_map
	Costs = Cost

func add_labels(Player_upgrade_counter: Dictionary) -> void:
	Player_upgrade_count = Player_upgrade_counter
	var Builder: String
	for I in range(Grid.size()):
		var Item_name = Item_category[I]
		Builder = Item_name+" "+Number_to_roman1[Player_upgrade_count[Item_name]]
		Grid[I].change_label(Builder)

func add_description(Index: int, Value: float) -> void:
	var Item_name = Item_category[Index]
	if Costs[Player_upgrade_count[Item_name]] == -1:
		Description_box.text = "Upgrade is Maxed Out"
	else:
		Description_box.text = "Cost: "+ str(Costs[Player_upgrade_count[Item_name]])+" coin\n"
		Description_box.text = Description_box.text+"Upgrade "+Item_category[Index]+". Increasing it by "+str(Value) 
		Description_box.text = Description_box.text + "\n Maxed at V"


# Updates the Coin amount
func update_coin(Coin:int):
	Coinlabel.text = str(Coin)

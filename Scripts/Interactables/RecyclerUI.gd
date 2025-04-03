extends Control

@onready var Grid: Array = $RecyclerPanel/ScrollContainer/RecycleGrid.get_children() #Slots
@onready var Trashlabel: Label = $RecyclerPanel/TrashLabel
@onready var Description_box:RichTextLabel = $RecyclerPanel/DescriptionTextLabel
@onready var Costs:Dictionary 
const Tier_to_text = {	0:"Common",
						1:"Uncommon",
						2:"Rare",
						3:"Epic",
						4:"Legendary"	}
						
const Number_to_roman1 = {	0:"I",
							1:"II",
							2:"III",
							3:"IV",
							4:"V"	}
						
@onready var Tier_items:Dictionary ={
	0:"""	Pierce
	Projectile Life
	Spin Sword
""",
	1:"""	Ricochet
""",
	2:"""	Spread Shot
	Multi Shot
""",
	3:"""""",
	4:"""""",
}


func add_labels(Cost: Dictionary) -> void:
	Costs = Cost
	var Builder: String
	for I in range(Grid.size()):
		Builder = Tier_to_text[I] + " Item"
		Grid[I].change_label(Builder)

func add_description(Index: int) -> void:
	Description_box.text = "Cost: "+str(Costs[Index])+" trash\n"
	Description_box.text = Description_box.text+"Randomly Produce a "+Tier_to_text[Index]+" item\n" + "Current Item Pool:\n"
	for I in range(Index+1):
		Description_box.text = Description_box.text + Tier_items[I]

#Toggle to see or not the Inventory UI
func toggle_recycler():
	self.visible = !self.visible

# Updates the Trash amount
func update_trash(Trash:int):
	Trashlabel.text = str(Trash)

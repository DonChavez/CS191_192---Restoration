extends Control

@onready var Grid1 = %RecyclerGrid.get_children() #Slots
@onready var Grid2 = %RecyclerGrid2.get_children() #Slots
@onready var Trashlabel = $RecyclerPanel/TrashLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	var Builder: Array = ["Common(1)", "Uncommon(5)", "Rare(10)", "Epic(25)", "Legendary(50)"]
	for I in range(Grid1.size()):
		Grid1[I].change_label(Builder[I])

	for I in range(Grid2.size()):
		Grid2[I].change_label(Builder[I+3])


#Toggle to see or not the Inventory UI
func toggle_recycler():
	self.visible = !self.visible

func update_trash(Trash:int):
	Trashlabel.text = str(Trash)

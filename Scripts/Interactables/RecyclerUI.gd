extends Control

@onready var Grid1 = $RecyclerPanel/CenterContainer/RecyclerGrid.get_children() #Slots
@onready var Grid2 = $RecyclerPanel/CenterContainer2/RecyclerGrid2.get_children() #Slots
@onready var Trashlabel = $RecyclerPanel/TrashLabel

var Builder: Array

func get_labels(Labels: Array) -> void:
	Builder = Labels.duplicate()
	for I in range(Grid1.size()):
		Grid1[I].change_label(Builder[I])

	for I in range(Grid2.size()):
		Grid2[I].change_label(Builder[I+3])

#Toggle to see or not the Inventory UI
func toggle_recycler():
	self.visible = !self.visible

# Updates the Trash amount
func update_trash(Trash:int):
	Trashlabel.text = str(Trash)

extends Control

@onready var Grid = $RecyclerPanel/ScrollContainer/RecycleGrid.get_children() #Slots
@onready var Trashlabel = $RecyclerPanel/TrashLabel

var Builder: Array

func get_labels(Labels: Array) -> void:
	Builder = Labels.duplicate()
	for I in range(Grid.size()):
		Grid[I].change_label(Builder[I])

#Toggle to see or not the Inventory UI
func toggle_recycler():
	self.visible = !self.visible

# Updates the Trash amount
func update_trash(Trash:int):
	Trashlabel.text = str(Trash)

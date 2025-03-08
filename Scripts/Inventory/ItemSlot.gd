extends TextureButton

signal CLICKED(Index: int)  # Define signal with a bool parameter
@onready var Array_indx: int = -1
@onready var The_label: Label = $CenterContainer/Label
@onready var Clicked: bool = false
@onready var Has_item: bool = false


func _ready():
	pass

func _on_pressed() -> void:
	CLICKED.emit(Array_indx)
	if Has_item:
		Clicked = !Clicked
		if Clicked:
			self_modulate = Color(0.8, 2.0, 0.8)  # Slightly darker when pressed

func toggle_item()-> void:
	Has_item = !Has_item

func reset() -> void:
	self_modulate = Color(1, 1, 1)  # Reset to normal
	Clicked = false

# Set Index of a wider array for inventory or recycler
func set_index(Index:int):
	Array_indx = Index

# Change titles if ever
func change_label(Text:String):
	The_label.text = Text

func _on_mouse_entered():
	if not Clicked:
		self_modulate = Color(1.2, 1.2, 1.2)  # Slightly brighter when hovered

func _on_mouse_exited():
	if not Clicked:
		self_modulate = Color(1, 1, 1)  # Reset to normal

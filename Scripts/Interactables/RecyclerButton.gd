extends TextureButton

signal CLICKED(Index: int, ID: int)  # Define signal with a bool parameter
@onready var Array_indx: int = -1
@onready var Row_ID: int = -1
@onready var The_label: Label = $CenterContainer/Label
@onready var Has_item: bool = false


func _ready():
	pass

func toggle_item()-> void:
	Has_item = !Has_item

# Set Index of a wider array for inventory or recycler
func set_index(Index:int):
	Array_indx = Index

# Set ID of a wider panel, special value for styling on Recycler
func set_id(ID:int):
	Row_ID = ID

# Change titles if ever
func change_label(Text:String):
	The_label.text = Text

func _on_mouse_entered():
	self_modulate = Color(1.5, 1.5, 1.5)  # Slightly brighter when hovered

func _on_mouse_exited():
	self_modulate = Color(1, 1, 1)  # Reset to normal


func _on_button_down() -> void:
	self_modulate = Color(1, 2, 1)


func _on_button_up() -> void:
	CLICKED.emit(Array_indx, Row_ID)
	self_modulate = Color(1, 1, 1)  # Reset to normal

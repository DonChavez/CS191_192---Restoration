extends TextureRect

signal CLICKED(Index: int)  # Define signal with a bool parameter
@onready var Array_indx: int = -1
@onready var Row_ID: int = -1
@onready var Hovering: bool = false
@onready var The_label: Label = $CenterContainer/Label

func _ready():
	pass
	
func _gui_input(Event: InputEvent):
	if Event is InputEventMouseButton and Event.pressed and Event.button_index == MOUSE_BUTTON_LEFT:
		var Mouse_pos = get_local_mouse_position()
		if Rect2(Vector2.ZERO, size).has_point(Mouse_pos):  # Only trigger if inside the slot
			print("Clicked on valid slot")
			CLICKED.emit(Array_indx, Row_ID)

# Set Index of a wider array for inventory or recycler
func set_index(Index:int):
	Array_indx = Index

# Set ID of a wider panel, special value for styling
func set_id(ID:int):
	Row_ID = ID

# Change titles if ever
func change_label(Text:String):
	The_label.text = Text

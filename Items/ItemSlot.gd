extends TextureButton

signal CLICKED(Index: int)  # Define signal with a bool parameter
@onready var Array_indx: int = -1
@onready var Row_ID: int = -1
@onready var The_label: Label = $CenterContainer/Label
@onready var Clicked: bool = false
@onready var Has_item: bool = false


func _ready():
	pass


# This instead of pressed to fix button presses
func _gui_input(Event: InputEvent):
	if Event is InputEventMouseButton and Event.pressed and Event.button_index == MOUSE_BUTTON_LEFT:
		var Mouse_pos = get_local_mouse_position()
		if Rect2(Vector2.ZERO, size).has_point(Mouse_pos):  # Only trigger if inside the slot
			print("Clicked on valid slot")
			_on_pressed()


func _on_pressed() -> void:
	CLICKED.emit(Array_indx, Row_ID)
	if Has_item:
		print(1)
		Clicked = !Clicked
		if Clicked:
			print(2)
			self_modulate = Color(0.8, 2.0, 0.8)  # Slightly darker when pressed

func toggle_item()-> void:
	Has_item = !Has_item

func reset() -> void:
	self_modulate = Color(1, 1, 1)  # Reset to normal
	Clicked = false

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
	if not Clicked:
		self_modulate = Color(1.2, 1.2, 1.2)  # Slightly brighter when hovered

func _on_mouse_exited():
	if not Clicked:
		self_modulate = Color(1, 1, 1)  # Reset to normal

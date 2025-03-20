extends TextureButton

signal CLICKED(Index: int)  # Define signal with a bool parameter
@onready var Array_indx: int = -1


@onready var Clicked: bool = false
@onready var Item_color: Color = Color(0,0,0,0)
@onready var Hover: bool = false
@onready var Show_desc: bool = false

func _on_pressed() -> void:
	CLICKED.emit(Array_indx)
	if Item_color.a != 0:
		Clicked = !Clicked
		if Clicked:
			self_modulate += Color(2.0, 2.0, 0.8)  # Slightly darker when pressed
			self_modulate -= Color(1.2, 1.2, 1.2)  # Remove hover color tint
# If item slot has item or not
func toggle_item(Item: ItemObject)-> void:
	if Item:
		Item_color = Item.get_default_color()

	else:
		Item_color.a = 0
	
# Reset its visuals and status
func reset() -> void:
	Clicked = false
	update_slot_ui()
	
func update_slot_ui() -> void:
	if Item_color.a != 0:
		self_modulate = Item_color
	else:
		self_modulate = Color(1,1,1)  # Reset to normal
	if Clicked:
		self_modulate += Color(2.0, 2.0, 0.8)
	elif Hover:
		self_modulate += Color(1.2,1.2,1.2)
# Set Index of a wider array for inventory or recycler
func set_index(Index:int):
	Array_indx = Index

func _on_mouse_entered():
	if not Clicked:
		self_modulate += Color(1.2, 1.2, 1.2)  # Slightly brighter when hovered
	Hover = true
	
	
func _on_mouse_exited():
	if not Clicked:# and Hover:
		self_modulate -= Color(1.2, 1.2, 1.2)  # Remove brighter when hovered
		pass
	Hover = false

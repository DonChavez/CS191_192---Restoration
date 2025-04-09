extends TextureButton

signal CLICKED(Index: int)  # Define signal with a bool parameter
@onready var Array_indx: int = -1

@onready var Item_icon: TextureRect = $ItemIcon

@onready var Clicked: bool = false
@onready var Hover: bool = false
@onready var Has_item: bool = false

func _on_pressed() -> void:
	CLICKED.emit(Array_indx)
	if Has_item:
		Clicked = !Clicked
		if Clicked:
			self_modulate += Color(2.0, 2.0, 0.8)  # Slightly darker when pressed
			self_modulate -= Color(1.2, 1.2, 1.2)  # Remove hover color tint
# If item slot has item or not
func toggle_item(Has: bool)-> void:
	Has_item = Has
	
func update_slot_ui() -> void:
	self_modulate = Color(1,1,1)  # Reset to normal
	if Clicked:
		self_modulate += Color(2.0, 2.0, 0.8)
	elif Hover:
		self_modulate += Color(1.2,1.2,1.2)


func toggle_item_ui(Item_texture) -> void:
	if Item_texture:
		Item_icon.texture = Item_texture
	else:
		Item_icon.texture = null
	update_slot_ui()
	

# Reset its visuals and status
func reset() -> void:
	Clicked = false
	update_slot_ui()
		
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

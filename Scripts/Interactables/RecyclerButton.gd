extends TextureButton

signal CLICKED(Index: int)  # Define signal with a bool parameter
@onready var Array_indx: int = -1
@onready var The_label: Label = $Label
var Base_text: String
func _ready():
	pass

# Set Index of a wider array for inventory or recycler
func set_index(Index:int):
	Array_indx = Index

# Change titles if ever
func change_label(Text:String):
	Base_text = Text
	The_label.text = Base_text

# Change cost value
func change_cost(Value: int) -> void:
	if Value == -1:
		The_label.text = Base_text + " (maxed)"
	else:
		The_label.text = Base_text + " ("+str(Value)+")"

func _on_mouse_entered():
	modulate += Color(5, 5, 5)  # Slightly brighter when hovered

func _on_mouse_exited():
	modulate = Color(1, 1, 1)  # Reset to normal

func _on_button_down() -> void:
	modulate = Color(1.5, 1.5, 1.5) # Clicked has green tint

func _on_button_up() -> void:
	CLICKED.emit(Array_indx)
	modulate = Color(1, 1, 1)  # Reset to normal

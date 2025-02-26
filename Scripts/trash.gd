extends Node2D

@onready var Input_label = $InputLabel
@onready var Inventory_manager = $"../PlayerCharacter/InventoryManager"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input_label.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	# Remove if interacted with
	if Input_label.visible and Input.is_action_just_pressed("interact"):
		queue_free()
		Inventory_manager.add_trash(10)
		print("Cleaned!")

# Interact button appears
func _on_area_2d_body_entered(body: Node2D) -> void:
	Input_label.visible = true

# Interact button disappears
func _on_area_2d_body_exited(body: Node2D) -> void:
	Input_label.visible = false

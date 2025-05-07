extends MarginContainer

@onready var trash_parts: Label = $Header/Control/VBoxContainer/Trash/TrashParts
@onready var objectives: Control = $Header/Control/VBoxContainer/Control

var inventory = null

func _ready() -> void:
	if PlayerManager.Player_instance != null:
		inventory = PlayerManager.Player_instance.get_node_or_null("UI Wrapper/Inventory")
		if inventory != null:
			if inventory.has_signal("trash_changed"):
				inventory.trash_changed.connect(_on_trash_changed)
			_update_trash_display()
		else:
			print("Error: Inventory node not found in player")
	else:
		print("Error: PlayerManager.player_instance is null")

	if trash_parts == null:
		print("Error: TrashParts Label not found")

	# Set initial visibility for objectives
	_update_objectives_visibility()

func _on_trash_changed(new_amount: int) -> void:
	_update_trash_display()

func _update_trash_display() -> void:
	if inventory != null and trash_parts != null:
		trash_parts.text = "%d" % inventory.Trash
	else:
		print("Cannot update TrashParts: inventory=", inventory, " trash_parts=", trash_parts)

func _update_objectives_visibility() -> void:
	if objectives != null:
		var current_scene = get_tree().current_scene
		objectives.visible = current_scene != null and current_scene.name == "The Tutorial"

func _process(_delta: float) -> void:
	if inventory != null and trash_parts != null:
		if trash_parts.text != "%d" % inventory.Trash:
			_update_trash_display()

	# Continuously check scene name in case of transition
	_update_objectives_visibility()

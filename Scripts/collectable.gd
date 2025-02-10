extends Area2D

@onready var inventory_manager = %InventoryManager

# Called when the node enters the scene tree for the first time.
func _on_body_entered(body):
	print("ding")
	queue_free()
	inventory_manager.add_coin()

extends Node

var coins = 0
@onready var label = $"../Invetory/coin_count"
@onready var inventory = $"../Invetory"

func add_coin():
	coins += 1
	label.text = str(coins)
func interact_inventory():
	inventory.visible =!inventory.visible
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	inventory.visible=false
	label.text = str(coins)

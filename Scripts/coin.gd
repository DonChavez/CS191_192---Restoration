extends Area2D

const Speed: float = 120
var Player: CharacterBody2D = null  
@onready var Animated_coin = $AnimatedCoin2D  # Get reference
@onready var Inventory_manager = $"../PlayerCharacter/InventoryManager"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Animated_coin.play("coin_spin") 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(Delta: float) -> void:
	if Player:
		var Direction = (Player.global_position - global_position).normalized()
		global_position += Direction * Speed * Delta # Move towards player
		if Player.position.distance_to(position) < 5.0:  # Allowed 5 pixel difference
			queue_free()
			Inventory_manager.add_coin(1)
			print("ding")

# Player is now the body where coin will go to
func _on_body_entered(Body: CharacterBody2D):
	Player = Body # Works if correct Collission Mappings

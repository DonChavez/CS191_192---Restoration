extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func apply_item(Item: Node2D, Unit:CharacterBody2D) -> void:
	if Item.check_applied():
		return
	Item_id = Item.get_id()
	match Item_id:
		"0001":
			Item.appled_toggle()
			player.Projectile_bounce_count += ADDITIONAL_BOUNCE_COUNT
		"1001":
			
		"2001":
			
		"3001":
			
		"4001":
			
		"0001":
			
		"0001":
			
		"0001":
			
		"0001":
			
		"0001":
			
		"0001":
			
		"0001":
			
		"0001":
			
		"0001":
			

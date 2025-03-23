extends CharacterBody2D

@onready var Sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var Dialogue: Control = $Dialogue
@onready var Guide: Label = $Label
@onready var Inventory_sell: Control = $InventorySell
@onready var Player: CharacterBody2D

var can_interact: bool = false  # Tracks if the player is in the interaction area
@onready var Showing_inv = false

func _ready():
	Sprite.play("default")
	Dialogue.visible = false
	Guide.visible = false
	Inventory_sell.send_trainer(self)
	
func _physics_process(_delta):
	if Showing_inv and Input.is_action_just_pressed("interact"):
		Inventory_sell.toggle_selling()
		Showing_inv = !Showing_inv
		Guide.visible = !Guide.visible
		Player.Can_process_input = !Player.Can_process_input
	
	elif Dialogue.visible and Input.is_action_just_pressed("interact"):
		Dialogue.visible = !Dialogue.visible  # Toggle visibility
		Inventory_sell.toggle_selling()
		Showing_inv = !Showing_inv
		Guide.visible = !Guide.visible

	elif can_interact and Input.is_action_just_pressed("interact"):  # Check if 'F' key is pressed
		Dialogue.visible = !Dialogue.visible  # Toggle visibility
		Player.Can_process_input = !Player.Can_process_input
	
func exit() -> void:
	Inventory_sell.toggle_selling()
	Player.Can_process_input = !Player.Can_process_input
	Guide.visible = !Guide.visible
	Showing_inv = false


func _on_area_2d_body_entered(Body: Node2D) -> void:
	if Body.is_in_group("Player"):  # Ensure only the player triggers it
		can_interact = true
		Guide.visible = true
		Player = Body
		Inventory_sell.send_player(Player)

func _on_area_2d_body_exited(Body: Node2D) -> void:
	if Body.is_in_group("Player"):
		can_interact = false
		Guide.visible = false
		Dialogue.visible = false  # Hide dialogue when leaving
		if Showing_inv:
			Inventory_sell.toggle_selling()
			Showing_inv = !Showing_inv
			Player.Can_process_input = !Player.Can_process_input

extends CharacterBody2D

@onready var Sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var Dialogue: Control = $Dialogue
@onready var Guide: Label = $Label
@onready var The_tab: Control = $Tab
@onready var Player: CharacterBody2D

var can_interact: bool = false  # Tracks if the player is in the interaction area
@onready var Showing_tab:bool = false

"""
The Tab is the UI panel that appears for selling/training
"""

func _ready():
	Sprite.play("default")
	Dialogue.visible = false
	Guide.visible = false

	The_tab.send_owner(self)
	
func _physics_process(_delta):
	# If showing tab, press F to leave
	if Showing_tab and Input.is_action_just_pressed("interact"):
		The_tab.toggle_tab()
		Showing_tab = !Showing_tab
		Guide.visible = !Guide.visible
		Player.Can_process_input = !Player.Can_process_input
	# If showing dialogue, press F to show Tab
	elif Dialogue.visible and Input.is_action_just_pressed("interact"):
		Dialogue.visible = !Dialogue.visible  # Toggle visibility
		The_tab.toggle_tab()
		Showing_tab = !Showing_tab
		Guide.visible = !Guide.visible
	# If interactable, press F to show dialogue
	elif can_interact and Input.is_action_just_pressed("interact"):  # Check if 'F' key is pressed
		Dialogue.visible = !Dialogue.visible  # Toggle visibility
		Player.Can_process_input = !Player.Can_process_input
	
# Exit buttom top right of the Tab
func exit() -> void:
	The_tab.toggle_tab()
	Player.Can_process_input = !Player.Can_process_input
	Guide.visible = !Guide.visible
	Showing_tab = false


func _on_area_2d_body_entered(Body: Node2D) -> void:
	if Body.is_in_group("Player"):  # Ensure only the player triggers it
		can_interact = true
		Guide.visible = true
		Player = Body
		The_tab.send_player(Player)

func _on_area_2d_body_exited(Body: Node2D) -> void:
	if Body.is_in_group("Player"):
		can_interact = false
		Guide.visible = false
		Dialogue.visible = false  # Hide dialogue when leaving
		if Showing_tab:
			The_tab.toggle_tab()
			Showing_tab = !Showing_tab
			Player.Can_process_input = !Player.Can_process_input

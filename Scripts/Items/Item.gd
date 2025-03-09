extends Node2D
class_name ItemObject

enum Existence { WORLD, INVENTORY, SHOP}
@onready var Input_label = $InputLabel
@onready var Item_ID:String = ""
@onready var Exist_in: Existence = Existence.WORLD 
@onready var Stackable: bool = false
@export var Spawn_animate: bool = true

# Other Nodes
@onready var Player: CharacterBody2D = null  
@onready var Inventory: InventoryObject = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input_label.visible = false
	spawn_object_animation()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(Delta: float) -> void:	# Add to Inventory if interacted
	if Exist_in == Existence.WORLD:
		if Input_label.visible and Input.is_action_just_pressed("interact"):
			Inventory.add_item(self)

# Pick up button appears
func _on_area_2d_body_entered(Body: Node2D):
	if !Player: # Creates connection between Item and Inventory
		Player = Body
		Inventory = Player.get_inventory()
	if Exist_in == Existence.WORLD:
		Input_label.visible = true

# Pick up button disappears
func _on_area_2d_body_exited(Body: Node2D):
	if Exist_in == Existence.WORLD:
		Input_label.visible = false
		
func spawn_object_animation() -> void:
	if !Spawn_animate:
		return
	$".".set_deferred("monitoring", false)

	var X_speed = 50  # Base horizontal movement
	var Y_speed = -400 # Initial upward movement
	var gravity = 9.8 # Gravity pulling down
	var MaxYSpeed = 370 # Maximum fall speed before stopping
	var Velocity = Vector2.ZERO  # Initial velocity
	Velocity.x = X_speed * randf_range(-1.5, 1.5)  # randomized horizontal movement
	Velocity.y = Y_speed  
	
	# Run movement in a coroutine (no need for _process)
	while Velocity.y < MaxYSpeed:
		Velocity.y += gravity  # Apply gravity
		position += Velocity * get_process_delta_time()  # Apply movement
		await get_tree().process_frame  # Wait for next frame
	
	$".".set_deferred("monitoring", true) 

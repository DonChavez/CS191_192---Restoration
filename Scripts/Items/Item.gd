extends Node2D
class_name ItemObject

enum Existence { WORLD, INVENTORY, SHOP}
@onready var Input_label = $InputLabel
@onready var Icon = $Icon
@export var Item_ID:String
@export var Item_name:String
@export var Stacking: bool

@onready var Exist_in: Existence = Existence.WORLD 

@export var Spawn_animate: bool = true
enum ItemType {RANGE, MELEE, PASSIVE}
@export var Item_type: ItemType
@onready var Item_tier:int
@onready var Default_color: Color


# For Description
@onready var Description: String
@onready var Title: String
const Tier_to_text = {	0:"Common",
						1:"Uncommon",
						2:"Rare",
						3:"Epic",
						4:"Legendary"	}

# Other Nodes
@onready var Inventory: InventoryObject = null

# Item effect-related properties
@onready var Effect_applied = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input_label.visible = false
	spawn_object_animation()
	Item_tier = int(Item_ID[0])

func change_ID(ID: String) -> void:
	Item_ID = ID
	Item_tier = int(Item_ID[0])

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(Delta: float) -> void:	# Add to Inventory if interacted
	if Exist_in == Existence.WORLD:
		if Input_label.visible and Input.is_action_just_pressed("interact"):
			Inventory.add_item(self)

# Pick up button appears
func _on_area_2d_body_entered(Body: Node2D):
	Inventory = Body.get_inventory()
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

func apply_tier(Tier:int) -> void:
	match Tier:
		0: Default_color = Color(1.0, 1.0, 1.0)  # Common White
		1: Default_color = Color(0.53, 1.0, 0.53)  # Uncommon Green
		2: Default_color = Color(0.53, 0.53, 1.0)  # Rare Blue
		3: Default_color = Color(0.8, 0.4, 0.8)  # Epic Purple (Fixed)
		4: Default_color = Color(1.0, 0.4, 0.4)   # Legendary Red
	Icon.self_modulate = Default_color
	
	
#-----for getting values methods-----#
func get_default_color() -> Color:
	return Default_color

func get_item_tier() -> int:
	return Item_tier
func get_item_id() -> String:
	return Item_ID
func get_applied() -> bool:
	return Effect_applied

func get_stacking() -> bool:
	return Stacking
#-----Application methods-----#

func applied_toggle() -> void:
	Effect_applied = !Effect_applied

# Override these in specific item scripts
func apply_effect(Player:CharacterBody2D):
	pass

func remove_effect(Player:CharacterBody2D):
	pass

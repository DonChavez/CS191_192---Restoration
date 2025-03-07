extends Area2D

# Other Nodes
@onready var Player: CharacterBody2D = null  
@onready var Inventory: InventoryObject = null

# Identity Variables
enum ItemType { TRASH, COIN }  # Define types
@export var Item_type: ItemType  # Select in Inspector
@export var Animatedsprite: AnimatedSprite2D  # Get reference
@export var Sprite: Sprite2D  # Get reference
@export var Value: int  # Get reference

# Local Variables
@onready var Speed: float = 200
@onready var Idle: bool = false
@onready var Base_position: Vector2  # Store the initial position
@onready var Idlespeed: float = 2.0  # How fast the object moves up/down
@onready var Amplitude: float = 8.0  # How far the object moves up/down
@onready var Time_elapsed: float  # Track elapsed time


# Called when the node enters the scene tree for the first time.
func _ready():
	if Animatedsprite:
		Animatedsprite.play("coin_spin") 
	
	await spawn_object()
	Base_position = position
	Idle = true
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(Delta: float) -> void:
	
	if Player:
		var Direction = (Player.global_position - global_position).normalized()
		global_position += Direction * Speed * Delta  # Move towards player
		if Player.position.distance_to(position) < 5.0:  # Allowed 5 pixel difference
			match Item_type:
				ItemType.TRASH:
					Inventory.add_trash(Value)
				ItemType.COIN:
					Inventory.add_coin()
			print("ding")
			queue_free()
	elif Idle:
		_idle_animation(Delta)
		
func _idle_animation(Delta: float) -> void:
	Time_elapsed +=  Delta  # Track elapsed time
	position.y = Base_position.y + sin(Time_elapsed*Idlespeed) * Amplitude

func _on_body_entered(Body: Node2D) -> void:
	Player = Body # Works if correct Collision Mapping
	Inventory = Player.get_inventory()
	

func spawn_object() -> void:
	$".".set_deferred("monitoring", false)

	var Xspeed = 50  # Base horizontal movement
	var Yspeed = -400 # Initial upward movement
	var gravity = 9.8 # Gravity pulling down
	var MaxYSpeed = 370 # Maximum fall speed before stopping
	var Velocity = Vector2.ZERO  # Initial velocity
	Velocity.x = Xspeed * randf_range(-1, 1)  # randomized horizontal movement
	Velocity.y = Yspeed  # Start with a strong upward force
	
	# Run movement in a coroutine (no need for _process)
	while Velocity.y < MaxYSpeed:
		Velocity.y += gravity  # Apply gravity
		position += Velocity * get_process_delta_time()  # Apply movement
		await get_tree().process_frame  # Wait for next frame # Wait for next frame
	
	$".".set_deferred("monitoring", true) 
	

extends Area2D

# Other Nodes
@onready var Player: CharacterBody2D = null  
@onready var Inventory: InventoryObject = null

#-----exportable variables-----#
enum ItemType { TRASH, COIN }  # Define types
@export var Item_type: ItemType  # Select in Inspector
@export var Animatedsprite: AnimatedSprite2D  # Get reference
@export var Sprite: Sprite2D  # Get reference
@export var Value: int  # Get reference
@export var Spawn_animate: bool = true

#-----local variables-----#
@onready var Speed: float = 200
@onready var Idle: bool = false
@onready var Base_position: Vector2  # Store the initial position
@onready var Idle_speed: float = 2.0  # How fast the object moves up/down
@onready var Amplitude: float = 8.0  # How far the object moves up/down
@onready var Time_elapsed: float  # Track elapsed time


# Called when the node enters the scene tree for the first time.
func _ready():
	# if coin, do spin animation
	if Animatedsprite:
		Animatedsprite.play("coin_spin") 
	# Do Spawn animation then Idle
	await spawn_object_animation()
	Base_position = position
	Idle = true
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(Delta: float) -> void:
	# If Player was detected
	if Player:
		# Move towards player
		var Direction = (Player.global_position - global_position).normalized()
		global_position += Direction * Speed * Delta 
		# Allowed 5 pixel difference before collected
		if Player.position.distance_to(position) < 5.0: 
			match Item_type:
				ItemType.TRASH:
					Inventory.add_trash(Value)
				ItemType.COIN:
					Inventory.add_coin(Value)
			print("ding")
			queue_free()
	elif Idle:
		# Idle Animation
		_idle_animation(Delta)

#Upon Player Entry Area
func _on_body_entered(Body: Node2D) -> void:
	Player = Body # Works if correct Collision Mapping
	Inventory = Player.get_inventory()
	Idle = false

# Oscillation movement
func _idle_animation(Delta: float) -> void:
	Time_elapsed +=  Delta  # Track elapsed time
	position.y = Base_position.y + sin(Time_elapsed*Idle_speed) * Amplitude

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
	

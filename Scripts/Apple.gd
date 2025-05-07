extends StaticBody2D

@export var Heal_amount : float = 20.0
@onready var Prompt_label: Label = $Label

var Player_nearby = false
var Spawn_animate = false

var Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Prompt_label.visible = false
	await spawn_object_animation()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Player_nearby and Input.is_action_just_pressed("interact"): 
		interact(Player.Player_health)

func interact(Player_health : HealthComponent) -> void:
	print("EAT ME")
	if Player_health.Health != Player_health.Max_health:
		Player_health.heal(Heal_amount)
		queue_free()

func _on_interaction_area_body_entered(body: Node2D) -> void:
	Player_nearby = true
	print("Hi Player!")
	Prompt_label.visible = true
	
	if body.is_in_group("Player"):
		Player = body


func _on_interaction_area_body_exited(body: Node2D) -> void:
	Player_nearby = false
	print("No! Don't go!")
	Prompt_label.visible = false
	
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

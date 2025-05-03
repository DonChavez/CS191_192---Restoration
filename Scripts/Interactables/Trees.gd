extends StaticBody2D

#-----signal variables-----#
signal EATTRASH(Amount : float)

#-----onready variables-----#

@onready var Interact_label: Label = $InteractLabel
@onready var Progress: ProgressBar = $ProgressBar
@onready var Tree_sprite: Sprite2D = $TreeSprite
@onready var Area_sprite: Sprite2D = $AreaSprite
@onready var Planting_timer: Timer = $CleaningTimer
@onready var Collision_body: CollisionShape2D = $CollisionShape2D

#-----local variables-----#
@onready var Planted: bool = false
@onready var Planting: bool = false
@onready var Just_plant: bool = false

#-----export variables-----#
@export var Plant_time: int = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var style_box := StyleBoxFlat.new()
	style_box.bg_color = Color(0, 1, 0)  # Red color
	Progress.add_theme_stylebox_override("fill", style_box)
	Tree_sprite.visible = false
	Interact_label.visible = false
	Progress.visible = false
	Progress.value = 0
	Collision_body.disabled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Interrupt cleaning if any key is pressed, but only after Just_clean has settled
	if Planting and Input.is_anything_pressed() and not Just_plant:
		Planting = false
		Planting_timer.stop()
		Progress.value = 0

	# Start cleaning on interact
	elif Interact_label.visible and Input.is_action_just_pressed("interact"):
		_start_planting()

func _start_planting() -> void:
	Just_plant = true
	Planting = true
	Planting_timer.start()
	await get_tree().create_timer(0.3).timeout  # Brief delay to skip interruption
	Just_plant = false

# Occurs every 0.1 seconds
func _update_planting_progress() -> void:
	if not Planting:
		Planting_timer.stop()
		return

	# Increment progress based on time elapsed
	var Increment = (Planting_timer.wait_time / Plant_time) * 100
	Progress.value += Increment

	# Check if cleaning is complete
	if Progress.value >= 100:
		Planting_timer.stop()
		Planted = true
		Planting = false
		Tree_sprite.visible = true
		Area_sprite.visible = false
		Interact_label.visible = false
		Progress.visible = false
		Collision_body.disabled = false
		EATTRASH.emit(10.0)
		# emit float signal of 10.0 to reduce pollution level 
		# emit signal to decrease pollution

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not Planted:
		Interact_label.visible = true
		Progress.visible = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	Interact_label.visible = false
	Progress.visible = false

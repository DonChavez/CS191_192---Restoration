extends StaticBody2D

#-----onready variables-----#
@onready var Interact_label: Label = $InteractLabel
@onready var Cleaned_sprite: Texture2D = load("res://Art/Objects/empty_trash.png")
@onready var Progress: ProgressBar = $ProgressBar
@onready var Sprite: Sprite2D = $Sprite2D
@onready var Cleaning_timer: Timer = $CleaningTimer
@onready var TC_trashspawn: Node = $TrashSpawn

#-----local variables-----#
@onready var Dirty: bool = true
@onready var Cleaning: bool = false
@onready var Just_clean: bool = false

#-----export variables-----#
@export var Clean_time: int = 5
@export var Amount_to_spawn: int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var style_box := StyleBoxFlat.new()
	style_box.bg_color = Color(0, 1, 0)  # Red color
	Progress.add_theme_stylebox_override("fill", style_box)
	Interact_label.visible = false
	Progress.value = 0
	Progress.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Interrupt cleaning if any key is pressed, but only after Just_clean has settled
	if Cleaning and Input.is_anything_pressed() and not Just_clean:
		Progress.value = 0
		Cleaning = false
		Cleaning_timer.stop()

	# Start cleaning on interact
	elif Interact_label.visible and Input.is_action_just_pressed("interact"):
		_start_cleaning()

# Start Cleaning with brief delay for bug fix
func _start_cleaning() -> void:
	Just_clean = true
	Cleaning = true
	Cleaning_timer.start()
	await get_tree().create_timer(0.3).timeout  # Brief delay to skip interruption
	Just_clean = false

# Occurs every 0.1 seconds
func _update_cleaning_progress() -> void:
	if not Cleaning:
		Cleaning_timer.stop()
		return

	# Increment progress based on time elapsed
	var Increment = (Cleaning_timer.wait_time / Clean_time) * 100
	Progress.value += Increment

	# Check if cleaning is complete
	if Progress.value >= 100:
		Cleaning_timer.stop()
		Sprite.texture = Cleaned_sprite
		Dirty = false
		Cleaning = false
		Interact_label.visible = false
		Progress.visible = false
		TC_trashspawn.spawn_trash(Amount_to_spawn)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if Dirty:
		Interact_label.visible = true
		Progress.visible = true	

func _on_area_2d_body_exited(body: Node2D) -> void:
	Interact_label.visible = false
	Progress.visible = false

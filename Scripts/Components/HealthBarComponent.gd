extends ProgressBar

@export var Health_component: HealthComponent

func _ready() -> void:
	if Health_component:
		# Connect the function to the changed signal of the health component
		Health_component.changed.connect(Callable(self,"_on_health_changed"))
		var Style_box = StyleBoxFlat.new()
		
		if Health_component.get_parent().is_in_group("Player"):
			Style_box.bg_color = Color.GREEN
		elif Health_component.get_parent().is_in_group("Shield"):
			Style_box.bg_color = Color.BLUE
		else:
			Style_box.bg_color = Color.RED
			
		add_theme_stylebox_override("fill", Style_box)
		# Initialize the ProgressBar with the current health
		_on_health_changed(Health_component.Health)
	else:
		# error for debugging
		print("no health component assigned for healthbar ", get_parent())

func _on_health_changed(New_health: float) -> void:
	var Health_percentage = (New_health / Health_component.Max_health) * 100
	# value only accepts in the range of 0-100
	value = Health_percentage
	# only visible if health is within the range of (0,100)
	visible = Health_percentage > 0 and Health_percentage < 100

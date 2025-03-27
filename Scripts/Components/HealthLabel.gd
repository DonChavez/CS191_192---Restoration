extends Label

@export var Health_component: HealthComponent

func _ready():
	if Health_component:
		Health_component.changed.connect(_on_health_component_changed)
		_on_health_component_changed(Health_component.Health)

func _on_health_component_changed(Health: float) -> void:
	text = "%s / %s" % [Health, Health_component.Max_health]

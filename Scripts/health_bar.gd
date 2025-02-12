extends ProgressBar

@export var health_component: HealthComponent

func _ready():
	if health_component:
		health_component.changed.connect(_on_health_component_changed)
		_on_health_component_changed(health_component.health)

func _on_health_component_changed(health: float) -> void:
	value = health

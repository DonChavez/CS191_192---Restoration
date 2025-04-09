extends HitboxComponent

@onready var Collision:CollisionShape2D = $LightCollisionShape2D


func _ready() -> void:
	self.monitorable = false
	self.monitoring = false
	self.visible = false
	
func change_size(X_size:float,Y_size) -> void:
	Collision.shape.extents.x = X_size
	Collision.shape.extents.y = Y_size
	
func change_location(X_location:float, Y_location:float) -> void:
	self.global_position.x = X_location
	self.global_position.y = Y_location

func toggle() -> void:
	self.monitorable = !self.monitorable
	self.monitoring = !self.monitoring
	self.visible = !self.visible

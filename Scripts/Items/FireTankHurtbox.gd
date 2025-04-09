extends HurtboxComponent

@onready var Collision:CollisionShape2D = $FireCollisionShape2D

func change_size(Radius:float) -> void:
	Collision.shape.radius = Radius

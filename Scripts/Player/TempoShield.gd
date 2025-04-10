extends Area2D

func _on_body_entered(body: Node2D) -> void:
	print("BOUNCE")
	if body.has_method("bounce") and body.Fired_by == "Enemy":  
		# Calculate the bounce normal
		var normal = (body.global_position - global_position).normalized()
		body.bounce(normal)

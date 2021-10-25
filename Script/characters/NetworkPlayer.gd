extends KinematicBody

signal hit

func _on_PlayerDetector_body_entered(body):
	if body.is_in_group("Players"):
		die()

func die():
	emit_signal("hit")
	queue_free()

extends RigidBody

onready var explosion_sfx = $"ExplosionSfx"

func _on_ExplosionTrigger_body_entered(body):
	if body.is_in_group("Players"):
		explosion_sfx.play()

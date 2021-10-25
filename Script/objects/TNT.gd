extends RigidBody

onready var explosion_anim = $"ExplosionAnim"

var is_already_exploded = false

func _on_ExplosionTrigger_body_entered(body):
	if body.is_in_group("Players"):
		if is_already_exploded:
			return
		
		for member in get_tree().get_nodes_in_group("Players"):
			var member_translation = member.get_translation()
			var member_rotation_degrees = member.get_rotation_degrees()
			member.move_and_collide(Vector3(member_rotation_degrees.x - 10, member_translation.y + 10, member_rotation_degrees.z - 10))
			member.set_health(0)

		explosion_anim.play("TNT-Explode")
		is_already_exploded = true
		yield(get_tree().create_timer(10), "timeout")
		queue_free()

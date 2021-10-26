extends RigidBody

onready var collision = $"CollisionShape"
onready var explosion_anim = $"ExplosionAnim"

var is_already_exploded = false

func explode():
	if is_already_exploded:
		return
	
	for member in get_tree().get_nodes_in_group("Players"):
		var decreased_health = member.get_translation().z / get_translation().z * 32
		
		if decreased_health > 0:
			member.decrease_health(decreased_health)

	is_already_exploded = true
	explosion_anim.play("TNT-Explode")
	collision.set_disabled(true)
	yield(get_tree().create_timer(5), "timeout")
	queue_free()

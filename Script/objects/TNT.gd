extends RigidBody

onready var collision = $"CollisionShape"
onready var explosion_anim = $"ExplosionAnim"

var is_already_exploded = false

func explode():
	for member in get_tree().get_nodes_in_group("Players"):
		member.decrease_health(30)

	is_already_exploded = true
	explosion_anim.play("TNT-Explode")
	collision.set_visible(false)
	yield(get_tree().create_timer(8), "timeout")
	queue_free()

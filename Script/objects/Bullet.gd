extends RigidBody

export var speed = 10.0 * 60.0
export var damage = 1

onready var timer = $"Timer"

var velocity = Vector3()

func _ready():
	timer.start()
	velocity = global_transform.origin.x * speed
	set_as_toplevel(true)

func _physics_process(delta):
	global_translate(velocity * delta)

func _on_Bullet_body_entered(body):
	if not body.is_in_group("Players"):
		return
	
	body.decrease_health(2)
	queue_free()

func _on_Timer_timeout():
	queue_free()

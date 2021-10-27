extends CanvasLayer

onready var health = $"Health"
onready var ammo = $"Ammo"

func set_health(hp: int):
	health.set_text("Health: " + str(hp) + "%")
	
	if hp < 1:
		health.set_text("Health: 0%")

func get_health_node()-> Node:
	return health

func set_ammo(text):
	ammo.set_text(text)

func get_ammo_node()-> Node:
	return ammo

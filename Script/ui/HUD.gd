extends CanvasLayer

onready var health = $"Health"
onready var ammo = $"Ammo"

func set_health(hp: int):
	health.set_text("Health: " + str(hp) + "%")
	
	if hp < 1:
		health.set_text("Health: 0%")

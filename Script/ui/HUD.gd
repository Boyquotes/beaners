extends CanvasLayer

onready var health = $"Health"

func set_health(hp: int):
	health.set_text("Health: " + str(hp) + "%")
	
	if hp < 1:
		health.set_text("Health: 0")

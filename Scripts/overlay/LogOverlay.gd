extends CanvasLayer

onready var Logs = $"Logs"

func msg(message: String):
	var text = Logs.get_text()
	var newline = "\n" if text.length() > 0 else ""
	Logs.set_text(text + newline + message) 

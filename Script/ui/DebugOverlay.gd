extends CanvasLayer

onready var label = $"Label"

var statistics = []

func _ready():
	pass

func add_statistics(stats_name, object, stats_reference, is_method):
	statistics.append([stats_name, object, stats_reference, is_method])

func _process(_delta):
	var fps = Engine.get_frames_per_second()
	var dynamic_memory = OS.get_dynamic_memory_usage()
	var static_memory = OS.get_static_memory_usage()
	var new_label = ""
	
	new_label += str("FPS: ", fps, "\n")
	new_label += str("Dynamic Memory: ", String.humanize_size(dynamic_memory), "\n")
	new_label += str("Static Memory: ", String.humanize_size(static_memory), "\n")
	
	for value in statistics:
		var new_value = null
		
		if value[1] and weakref(value[1]).get_ref():
			if value[3]:
				new_value = value[1].call(value[2])
			else:
				new_value = value[1].get(value[2])
		
		new_label += str(value[0], ": ", new_value)
		new_label += "\n"
	
	label.set_text(new_label)

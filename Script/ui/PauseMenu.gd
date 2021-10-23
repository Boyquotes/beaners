extends MarginContainer

const mmenu = preload("res:///Scene/ui/MainMenu.tscn")

onready var world = $"../../"
onready var selector_resume = $"CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer3/HBoxContainer/ResumeSelector"
onready var selector_options = $"CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer2/HBoxContainer/OptionsSelector" 
onready var selector_mmenu = $"CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer4/HBoxContainer/MMenuSelector"
onready var selector_quit = $"CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer/HBoxContainer/QuitSelector"

var current_selection = 0

func _ready():
	update_current_selection()

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		yield(get_tree().create_timer(100), "timeout")
		current_selection = 0
		handle_selection()
	
	if Input.is_action_just_pressed("ui_up") and current_selection > 0:
		current_selection -= 1
		update_current_selection()
	elif Input.is_action_just_pressed("ui_down") and current_selection < 3:
		current_selection += 1
		update_current_selection()
	elif Input.is_action_just_pressed("ui_accept"):
		handle_selection()

func handle_selection():
	if current_selection == 0:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		queue_free()
	elif current_selection == 1:
		print("Options coming soon!")
	elif current_selection == 2:
		get_tree().root.add_child(mmenu.instance())
		world.queue_free()
		queue_free()
	elif current_selection == 3:
		get_tree().quit()

func update_current_selection():
	var selection = current_selection
	selector_resume.set_text("")
	selector_options.set_text("")
	selector_mmenu.set_text("")
	selector_quit.set_text("")
	
	if selection == 0:
		selector_resume.set_text(">")
	elif selection == 1:
		selector_options.set_text(">")
	elif selection == 2:
		selector_mmenu.set_text(">")
	elif selection == 3:
		selector_quit.set_text(">")

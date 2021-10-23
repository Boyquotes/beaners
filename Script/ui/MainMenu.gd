extends MarginContainer

onready var world = preload("res:///Scene/worlds/Void.tscn")
onready var selector_play = $"CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer3/HBoxContainer/PlaySelector"
onready var selector_options = $"CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer2/HBoxContainer/OptionsSelector" 
onready var selector_quit = $"CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer/HBoxContainer/QuitSelector"
onready var navigate_sfx = $"NavigateSfx"
onready var select_sfx = $"SelectSfx"
onready var back_sfx = $"BackSfx"

var current_selection = 0

func _ready():
	current_selection = 0
	update_current_selection()

func _process(_delta):
	if Input.is_action_just_pressed("ui_up") and current_selection > 0:
		current_selection -= 1
		update_current_selection()
	elif Input.is_action_just_pressed("ui_down") and current_selection < 2:	
		current_selection += 1
		update_current_selection()
	elif Input.is_action_just_pressed("ui_accept"):
		handle_selection()

func handle_selection():
	select_sfx.play()
	
	if current_selection == 0:
		get_parent().add_child(world.instance())
		queue_free()
	elif current_selection == 1:
		print("Options coming soon!")
	elif current_selection == 2:
		get_tree().quit()

func update_current_selection():
	navigate_sfx.play()
	var selection = current_selection
	selector_play.set_text("")
	selector_options.set_text("")
	selector_quit.set_text("")
	
	if selection == 0:
		selector_play.set_text(">")
	elif selection == 1:
		selector_options.set_text(">")
	elif selection == 2:
		selector_quit.set_text(">")

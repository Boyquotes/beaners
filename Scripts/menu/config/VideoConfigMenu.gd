extends MarginContainer

var default_font_color = Color(1, 1, 1, 1)
var hover_font_color = Color("#D3D3D3")

var ingame_menu = false

onready var BackgroundColor = $"BackgroundColor"

onready var BackOption = $"Root/MarginContents/Contents/NavigationContents/BackOption"

onready var ModeOption = $"Root/MarginContents/Contents/ModeOption"
onready var ModeOptionLabel = $"Root/MarginContents/Contents/ModeOption/ModeOptionLabel"
onready var ModeOptionMenu = $"Root/MarginContents/Contents/ModeOption/ModeOptionMenu"

onready var VsyncOption = $"Root/MarginContents/Contents/VsyncOption"
onready var VsyncOptionLabel = $"Root/MarginContents/Contents/VsyncOption/VsyncOptionLabel"
onready var VsyncOptionBox = $"Root/MarginContents/Contents/VsyncOption/VsyncOptionBox"

onready var GraphicsSubheader = $"Root/MarginContents/Contents/GraphicsSubheader"

onready var ShadowsOption = $"Root/MarginContents/Contents/ShadowsOption"
onready var ShadowsOptionLabel = $"Root/MarginContents/Contents/ShadowsOption/ShadowsOptionLabel"
onready var ShadowsOptionMenu = $"Root/MarginContents/Contents/ShadowsOption/ShadowsOptionMenu"

onready var TexturesOption = $"Root/MarginContents/Contents/TexturesOption"
onready var TexturesOptionLabel = $"Root/MarginContents/Contents/TexturesOption/TexturesOptionLabel"
onready var TexturesOptionMenu = $"Root/MarginContents/Contents/TexturesOption/TexturesOptionMenu"

onready var ScaleOption = $"Root/MarginContents/Contents/ScaleOption"
onready var ScaleOptionLabel = $"Root/MarginContents/Contents/ScaleOption/ScaleOptionLabel"
onready var ScaleOptionSlider = $"Root/MarginContents/Contents/ScaleOption/ScaleOptionSlider"

export var option_selection = -1

func _ready():
	# Set sliders and menu indexes from saved video configuration
	ModeOptionMenu.select()
	VsyncOptionBox.set_pressed(ConfigWatcher.get_video_config().is_display_vsync_enabled())
	ShadowsOptionMenu.select(ConfigWatcher.get_video_config().get_shadow_quality())
	TexturesOptionMenu.select(ConfigWatcher.get_video_config().get_texture_quality())
	ScaleOptionSlider.set_value(ConfigWatcher.get_video_config().get_ui_scale())
	
	# UI scaling isn't supported on mobile devices
	if OS.get_name() == "Android":
		ScaleOptionSlider.set_editable(false)

func _input(event):
	if event is InputEventMouseMotion:
		# Show the mouse cursor if moved
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _process(_delta):
	# Put a little warning on the graphics subheader if in-game
	if is_ingame_menu():
		GraphicsSubheader.set_text("Graphics (restart required)")
	# Call handle_opt_selection for the accept input action
	if Input.is_action_just_pressed("ui_accept"):
		handle_opt_selection()
	# Return to main menu for the cancel input action
	if Input.is_action_just_pressed("ui_cancel"):
		option_selection = 0
		handle_opt_selection()

func handle_opt_selection():
	# Handle selected option, this is used when pressing the accept input action
	UiSoundGlobals.Select.play()
	
	if option_selection == -1:
		option_selection = 1
	if option_selection == 0:
		if is_ingame_menu():
			get_parent().set_process_input(true)
			get_parent().set_process(true)
			get_parent().remove_child(self)
			queue_free()
		else:
			# warning-ignore:return_value_discarded
			get_tree().change_scene("res://Scenes/menu/ConfigMenu.tscn")

func update_opt_selection():
	# This function must be called after option_selection has changed
	# Reset all the options first before doing anything else
	BackOption.add_color_override("font_color", default_font_color)
	ModeOptionLabel.add_color_override("font_color", default_font_color)
	VsyncOptionLabel.add_color_override("font_color", default_font_color)
	ShadowsOptionLabel.add_color_override("font_color", default_font_color)
	TexturesOptionLabel.add_color_override("font_color", default_font_color)
	ScaleOptionLabel.add_color_override("font_color", default_font_color)
	
	if option_selection != -1: UiSoundGlobals.Navigate.play()
	
	# Then do something to the options depending on the selection
	if option_selection == 0:
		BackOption.add_color_override("font_color", hover_font_color)
	elif option_selection == 1:
		ModeOptionLabel.add_color_override("font_color",
			hover_font_color)
	elif option_selection == 2:
		VsyncOptionLabel.add_color_override("font_color",
			hover_font_color)
	elif option_selection == 3:
		ShadowsOptionLabel.add_color_override("font_color",
			hover_font_color)
	elif option_selection == 4:
		TexturesOptionLabel.add_color_override("font_color",
			hover_font_color)
	elif option_selection == 5:
		ScaleOptionLabel.add_color_override("font_color",
			hover_font_color)

func reset_opt_selection():
	option_selection = -1
	update_opt_selection()

func toggle_ingame_menu(enable: bool):
	ingame_menu = enable

func is_ingame_menu() -> bool:
	return ingame_menu

func _on_ModeOptionMenu_item_selected(index):
	if index == 0:
		OS.set_window_fullscreen(false)
	elif index == 1:
		OS.set_window_fullscreen(true)
	
	ConfigWatcher.get_video_config().set_display_mode(index)

func _on_VsyncOptionBox_toggled(pressed):
	if UiSoundGlobals.Select.is_playing():
		UiSoundGlobals.Select.stop()
	
	UiSoundGlobals.Select.play()
	OS.set_use_vsync(pressed)
	ConfigWatcher.get_video_config().set_display_vsync(pressed)

func _on_ShadowsOptionMenu_item_selected(index):
	ConfigWatcher.get_video_config().set_shadow_quality(index)

func _on_TexturesOptionMenu_item_selected(index):
	ConfigWatcher.get_video_config().set_texture_quality(index)

func _on_ScaleOptionSlider_value_changed(value):
	var config = ConfigWatcher.get_video_config()
	var size = config.get_window_size()
	config.set_ui_scale(value)
	
	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D,
		SceneTree.STRETCH_ASPECT_EXPAND, size, value)

func _on_BackOption_mouse_entered():
	if option_selection == 0: return
	option_selection = 0
	update_opt_selection()

func _on_BackOption_mouse_exited():
	reset_opt_selection()

func _on_BackOption_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		handle_opt_selection()
	if event is InputEventScreenTouch and event.is_pressed():
		option_selection = 0
		handle_opt_selection()

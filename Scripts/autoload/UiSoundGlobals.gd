extends Node

var Inaccessible = AudioStreamPlayer.new()
var Navigate = AudioStreamPlayer.new()
var Select = AudioStreamPlayer.new()

const INACCESSIBLE_PATH = "res://Assets/sfx/ui-inaccessible.wav"
const NAVIGATE_PATH = "res://Assets/sfx/ui-navigate.wav"
const SELECT_PATH = "res://Assets/sfx/ui-select.wav"

const SFX_BUS = "In-Game"

func _ready():
	# Initialize sound effects
	Inaccessible.set_pause_mode(Node.PAUSE_MODE_PROCESS)
	Navigate.set_pause_mode(Node.PAUSE_MODE_PROCESS)
	Select.set_pause_mode(Node.PAUSE_MODE_PROCESS)
	
	Inaccessible.set_stream(load(INACCESSIBLE_PATH))
	Navigate.set_stream(load(NAVIGATE_PATH))
	Select.set_stream(load(SELECT_PATH))
	
	Inaccessible.set_bus(SFX_BUS)
	Navigate.set_bus(SFX_BUS)
	Select.set_bus(SFX_BUS)
	
	# Reduce volume for Select and Navigate sound effects
	Navigate.set_volume_db(-15.0)
	Select.set_volume_db(-15.0)
	
	# Add them as children to this node
	add_child(Inaccessible)
	add_child(Navigate)
	add_child(Select)

extends Node2D

signal spice_added

var current_spice: int

# Called when the node enters the scene tree for the first time.
func _ready():
	set_current_spice(-1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	position = get_viewport().get_mouse_position()

func _on_pot_selected():
	set_current_spice(-1)
	# TODO: message recipe manager

func _on_spice_selected(id: int):
	set_current_spice(id)

func set_current_spice(id: int):
	print("current spice is now ", id)
	current_spice = id

extends Node2D

signal pot_selected

@export var opening : Sprite2D;

# Called when the node enters the scene tree for the first time.
func _ready():
	opening.set_state(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_pot_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			pot_selected.emit()

func set_state(new_state):
	opening.set_state(new_state)

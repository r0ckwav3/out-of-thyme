extends Node2D

signal spice_added(id)

var current_spice: int
var texture_dict = {}
var jar_sprite_obj

# Called when the node enters the scene tree for the first time.
func _ready():
	jar_sprite_obj = get_child(0)
	set_current_spice(-1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	# position = get_viewport().get_mouse_position()

func _on_spice_init(spices):
	for s in spices:
		var sprite_name = s["texture"]
		var sprite_texture = load("res://Assets/Objects/Jars/"+sprite_name)
		if sprite_texture is Texture2D:
			texture_dict[s["id"]] = sprite_texture

func _on_pot_selected():
	spice_added.emit(current_spice)
	set_current_spice(-1)

func _on_spice_selected(id: int):
	set_current_spice(id)

func set_current_spice(id: int):
	print("current spice is now ", id)
	if id == -1:
		jar_sprite_obj.visible = false
	else:
		jar_sprite_obj.visible = true
		jar_sprite_obj.texture = texture_dict[id]
	current_spice = id

func _input(event):
	if event is InputEventMouseMotion:
		position = event.position

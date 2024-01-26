extends Node2D

signal item_selected(item_id)

@export var item_name = "None"
@export var item_id = -1
@export var sprite_name = "Jar_Liquid_brown.png"

var sprite_obj
var anim_obj

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite_obj = get_child(0) # is there a better way to grab this?
	anim_obj = get_child(2)
	
	var sprite_texture = load("res://Assets/Objects/Jars/"+sprite_name)
	if sprite_texture is Texture2D:
		sprite_obj.get_child(0).set_texture(sprite_texture)
	
	sprite_obj.get_child(1).text = item_name
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			#print("clicked on jar containing ", item_name, ", id: ", item_id)
			item_selected.emit(item_id)

func _on_area_2d_mouse_entered():
	anim_obj.play("Hover_Enlarge")


func _on_area_2d_mouse_exited():
	anim_obj.play("Hover_Shrink")

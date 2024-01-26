extends RayCast2D

var last_obj = null;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	set_global_position(get_viewport().get_mouse_position())
	if is_colliding():
		var new_obj = get_collider().get_parent()
		if new_obj != last_obj:
			print("hovering now ", new_obj.name)
			if is_jar(last_obj):
				last_obj.set_hovered(false)
			if is_jar(new_obj):
				new_obj.set_hovered(true)
			last_obj = new_obj
	else:
		if last_obj != null:
			print("not hovering now")
			if is_jar(last_obj):
				last_obj.set_hovered(false)
			last_obj = null

func is_jar(obj: Node):
	if obj == null:
		return false
	if obj.name == "Jar": # this is such a bad way to do this
		return true
	return false

#func _input(event):
	#if event is InputEventMouseButton:
		#if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			#print("click!")

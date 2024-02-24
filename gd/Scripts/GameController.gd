extends Node2D

@export var mainmenu_scene_path : String
# Put very little stuff in here if possible

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_recipe_finished(success):
	if success:
		print("recipe success!")
	else:
		print("recipe failed!")
	get_tree().change_scene_to_file(mainmenu_scene_path);

extends Sprite2D

var spriteoptions = ["Effects/Strikethrough1.png","Effects/Strikethrough2.png","Effects/Strikethrough3.png"]
var spritechosen

# Called when the node enters the scene tree for the first time.
func _ready():
	spritechosen = spriteoptions[randi() % len(spriteoptions)]
	texture = load("res://Assets/" + spritechosen)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

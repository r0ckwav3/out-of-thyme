extends Node2D

signal item_selected(item_id)

@export var Jar: PackedScene
@export var num_jars = 4
@export_group("Positioning")
@export var dx = 350
@export var dy = -100

var jars = []

# Called when the node enters the scene tree for the first time.
func _ready():
	# setup the jars
	var curr_x = 0
	for i in range(num_jars):
		var newjar = Jar.instantiate()
		# TODO: change when I make the item system
		newjar.item_name = "Test item " + str(i)
		newjar.item_id = i
		
		newjar.position.x = curr_x
		newjar.position.y = 0 if i%2 == 0 else dy
		curr_x += dx
		
		newjar.item_selected.connect(_on_child_selected)
		
		jars.append(newjar)
		add_child(newjar)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_child_selected(item_id):
	item_selected.emit(item_id)

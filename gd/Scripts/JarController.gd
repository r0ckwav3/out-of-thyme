extends Node2D

signal item_selected(item_id)

@export var Jar: PackedScene
@export var num_jars = 4
@export var spice_list_start = 0
@export_group("Positioning")
@export var dx = 350
@export var dy = -100

var jar_setup = false
var jars = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_spice_init(spices):
	# TODO: add better logic to just display less jars
	assert(len(spices) >= num_jars + spice_list_start)
	# setup the jars
	var curr_x = 0
	for i in range(num_jars):
		var spice_data = spices[spice_list_start + i]
		var newjar = Jar.instantiate()
		
		newjar.item_id = spice_data["id"]
		newjar.item_name = spice_data["name"]
		newjar.sprite_name = spice_data["texture"]
		
		newjar.position.x = curr_x
		newjar.position.y = 0 if i%2 == 0 else dy
		curr_x += dx
		
		newjar.item_selected.connect(_on_child_selected)
		
		jars.append(newjar)
		add_child(newjar)
	
	jar_setup = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_child_selected(item_id):
	item_selected.emit(item_id)

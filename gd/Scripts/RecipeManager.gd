extends Node

signal spices_intialized(spices)

@export var num_spices = 4
var chosen_spices = []

# Called when the node enters the scene tree for the first time.
func _ready():
	parse_spices()

func parse_spices():
	var spice_json = load("res://Data/spices.json")
	assert(typeof(spice_json.data) == TYPE_ARRAY)
	var parse1 = spice_json.data
	parse1.shuffle()
	assert(len(parse1) >= num_spices)
	for i in range(num_spices):
		assert(typeof(parse1[i]) == TYPE_DICTIONARY)
		var parse2 = parse1[i]
		parse2["id"] = int(parse2["id"])
		chosen_spices.append(parse2)
	
	spices_intialized.emit(chosen_spices)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

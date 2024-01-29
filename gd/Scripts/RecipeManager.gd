extends Node2D

signal spices_intialized(spices)
signal health_changed(old, new)
signal recipe_completed

@export var health = 3
@export var num_spices = 4
@export var num_steps = 4
var chosen_spices = []
var recipe = [] # each element is a tuple (steptype, spice_id)
var completed_steps = 0

enum RecipeStepType{
	ADD_SPICE,
	USE_TOOL,
}

# Called when the node enters the scene tree for the first time.
func _ready():
	parse_spices()
	generate_recipe()

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

func generate_recipe():
	for i in range(num_steps):
		var spice = chosen_spices[randi() % num_spices]
		recipe.append([RecipeStepType.ADD_SPICE, spice["id"]])

func _on_spice_added(spice_id):
	if recipe[completed_steps][0] == RecipeStepType.ADD_SPICE and recipe[completed_steps][1] == spice_id:
		correct_step()
	else:
		incorrect_step()

func correct_step():
	print("correct!")
	completed_steps += 1
	if completed_steps == num_steps:
		recipe_completed.emit()
	
func incorrect_step():
	health_changed.emit(health, health-1)
	health -= 1
	print("incorrect :( health is now ", health)

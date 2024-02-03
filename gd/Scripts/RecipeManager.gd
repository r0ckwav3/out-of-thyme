extends Node2D

signal spices_intialized(spices)
signal health_changed(old, new)
signal recipe_completed

@export var health = 3
@export var num_spices = 4
@export var num_steps = 4
var chosen_spices = []

var random_seed

# each element is a dict with key "type"
# other keys may include: "spice_id"
var recipe = []
var completed_steps = 0

var title

enum RecipeStepType{
	ADD_SPICE,
	USE_TOOL,
}

# Called when the node enters the scene tree for the first time.
func _ready():
	var random_seed = randi()
	
	parse_spices()
	generate_recipe()
	title = generate_title()

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
	const randomoffset = 2
	var randomizer = RandomNumberGenerator.new()
	randomizer.seed = random_seed + randomoffset
	for i in range(num_steps):
		var spice = chosen_spices[randomizer.randi() % num_spices]
		recipe.append({"type": RecipeStepType.ADD_SPICE, "spice_id": spice["id"]})

func generate_title():
	var json = load("res://Data/recipe_title_cfg.json")
	var recipe_title_cfg = json.data
	
	const randomoffset = 3803574094
	var randomizer = RandomNumberGenerator.new()
	var s = recipe_title_cfg["start"]
	var i = 0
	while i < len(s):
		if s[i] == "[":
			var end = s.find("]", i)
			assert(end != -1)
			var contents = s.substr(i+1, end-i-1)
			assert(contents in recipe_title_cfg["cfg"])
			var options = recipe_title_cfg["cfg"][contents]
			assert(len(options) != 0)
			var substitute = options[randomizer.randi() % len(options)]
			s = s.substr(0, i) + substitute + s.substr(end+1)
		else:
			i += 1
	return s

func recipe_line_text(line_num):
	var line = recipe[line_num]
	if line["type"] == RecipeStepType.ADD_SPICE:
		return "Add a "

func _on_spice_added(spice_id):
	if recipe[completed_steps]["type"] == RecipeStepType.ADD_SPICE and recipe[completed_steps]["spice_id"] == spice_id:
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

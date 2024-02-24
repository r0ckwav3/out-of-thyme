extends Node2D

signal spices_intialized(spices)
signal recipe_text_intialized(title, body)
signal step_completed(steps_done)
signal recipe_completed
signal recipe_failed

@export var num_spices = 4
@export var num_steps = 4
@export var starting_time = 60
var chosen_spices = []

# each element is a dict with key "type"
# other keys may include: "spice_id"
var recipe = []
var completed_steps = 0

var title

var timer_child
var label_child

enum RecipeStepType{
	ADD_SPICE,
	USE_TOOL,
}

# Called when the node enters the scene tree for the first time.
func _ready():
	# randomize()
	seed(145346341)
	
	timer_child = get_child(0)
	label_child = get_child(1)
	timer_child.wait_time = starting_time
	
	parse_spices()
	generate_recipe()
	title = generate_title()
	
	recipe_text_intialized.emit(title, generate_recipe_text())
	

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
		recipe.append({"type": RecipeStepType.ADD_SPICE, "spice_id": spice["id"]})

func generate_title():
	var json = load("res://Data/recipe_title_cfg.json")
	var recipe_title_cfg = json.data
	
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
			var substitute = options[randi() % len(options)]
			s = s.substr(0, i) + substitute + s.substr(end+1)
		else:
			i += 1
	return s

func recipe_line_text(line_num):
	var line = recipe[line_num]
	if line["type"] == RecipeStepType.ADD_SPICE:
		# TODO: randomize measurements
		return "%d. Add a pinch of %s." % [line_num+1, get_spice_by_id(line["spice_id"])["name"]]

func generate_recipe_text():
	var ans = ""
	for i in range(num_steps):
		ans += recipe_line_text(i) + "\n"
	return ans

func get_spice_by_id(spice_id):
	for s in chosen_spices:
		if s["id"] == spice_id:
			return s

func _on_spice_added(spice_id):
	if recipe[completed_steps]["type"] == RecipeStepType.ADD_SPICE and recipe[completed_steps]["spice_id"] == spice_id:
		correct_step()
	else:
		incorrect_step()

func _on_timer_finished():
	recipe_failed.emit()

func correct_step():
	print("correct!")
	completed_steps += 1
	step_completed.emit(completed_steps)
	if completed_steps == num_steps:
		recipe_completed.emit()
	
func incorrect_step():
	print("incorrect :(")

func _process(_delta):
	display_timer()

func display_timer():
	var secondsleft = int(floor(timer_child.time_left))
	var minutes = secondsleft / 60
	var seconds = secondsleft % 60
	label_child.text = "%02d:%02d" % [minutes,seconds]

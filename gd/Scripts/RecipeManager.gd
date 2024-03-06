extends Node2D

signal spices_intialized(spices)
signal recipe_text_intialized(title, body, disruptions)
signal step_completed(steps_done)
signal update_disruption(disruption_id)
signal recipe_completed
signal recipe_failed

@export var num_spices = 4
@export var num_steps = 4
@export var steps_per_disruption = 2
@export var num_disruptions = 1
@export var starting_time = 60
var chosen_spices = []

# each element is a dict with key "type"
# other keys may include: "spice_id", "disruption_id", "distruption_step"
var recipe = []
var disruptions = {}
var completed_steps = 0
var completed_normal_steps = 0

var title
var other_word_lists

var timer_child
var label_child
var my_seed # use within single functions, not the same as the global seed


enum RecipeStepType{
	ADD_SPICE,
	DISRUPTION_STEP,
}

# Called when the node enters the scene tree for the first time.
func _ready():
	# randomize()
	seed(10133231)
	my_seed = randi()
	
	timer_child = get_child(0)
	label_child = get_child(1)
	timer_child.wait_time = starting_time
	
	load_word_lists()
	parse_spices()
	parse_disruptions()
	
	generate_recipe()
	title = generate_title()
	
	recipe_text_intialized.emit(
		title,
		generate_recipe_text(),
		generate_disruption_guide_text())

func load_word_lists():
	other_word_lists = load("res://Data/other_word_lists.json").data

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

func parse_disruptions():
	var disruption_json = load("res://Data/disruptions.json").data
	for i in range(len(disruption_json)):
		var d = disruption_json[i]
		var dsteps = []
		for j in range(steps_per_disruption):
			var spice = chosen_spices[randi() % num_spices]
			dsteps.append({"type": RecipeStepType.ADD_SPICE, "spice_id": spice["id"]})
		
		disruptions[d["id"]] = {
			"id": d["id"],
			"name": d["name"],
			"desc": d["desc"],
			"steps": dsteps
		}

func generate_recipe():
	for i in range(num_steps):
		var spice = chosen_spices[randi() % num_spices]
		recipe.append({"type": RecipeStepType.ADD_SPICE, "spice_id": spice["id"]})
	
	# add disruptions
	# we do this weird order so that you can't nest disruptions
	var disruption_indecies = []
	for i in range(num_disruptions):
		var to_insert = (randi()%(num_steps-1))+1
		disruption_indecies.append(to_insert)
	disruption_indecies.sort()
	disruption_indecies.reverse()
	for i in range(num_disruptions):
		var disruption_id = disruptions.keys()[randi() % len(disruptions)]
		for j in range(len(disruptions[disruption_id]["steps"])):
			recipe.insert(disruption_indecies[i]+j,{
				"type": RecipeStepType.DISRUPTION_STEP,
				"disruption_id": disruption_id,
				"disruption_step": j
			})

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

func generate_recipe_text():
	var ans = ""
	var rng = RandomNumberGenerator.new()
	rng.seed = my_seed
	var measurements = other_word_lists["measurements"]
	var visiblecount = 0
	for i in range(len(recipe)):
		var line = recipe[i]
		if line["type"] == RecipeStepType.ADD_SPICE:
			var measureword = measurements[rng.randi() % len(measurements)]
			ans += "%d. Add %s %s." % [visiblecount+1, measureword, get_spice_by_id(line["spice_id"])["name"]]
			ans += "\n"
			visiblecount+=1
	return ans

func generate_disruption_guide_text():
	var ans = ""
	var rng = RandomNumberGenerator.new()
	rng.seed = my_seed
	var measurements = other_word_lists["measurements"]
	for d_id in disruptions:
		ans += disruptions[d_id]["name"] + ":\n"
		ans += disruptions[d_id]["desc"] + ",\n"
		var visiblecount = 0
		for i in range(len(disruptions[d_id]["steps"])):
			var line = disruptions[d_id]["steps"][i]
			if line["type"] == RecipeStepType.ADD_SPICE:
				var measureword = measurements[rng.randi() % len(measurements)]
				ans += "%d. Add %s %s." % [visiblecount+1, measureword, get_spice_by_id(line["spice_id"])["name"]]
				ans += "\n"
				visiblecount+=1
		ans += "\n"
	return ans

func get_spice_by_id(spice_id):
	for s in chosen_spices:
		if s["id"] == spice_id:
			return s

func _on_spice_added(spice_id):
	if recipe[completed_steps]["type"] == RecipeStepType.ADD_SPICE and recipe[completed_steps]["spice_id"] == spice_id:
		correct_step()
	elif recipe[completed_steps]["type"] == RecipeStepType.DISRUPTION_STEP:
		var disruption_id = recipe[completed_steps]["disruption_id"]
		var disruption_step = recipe[completed_steps]["disruption_step"]
		var substep = disruptions[disruption_id]["steps"][disruption_step]
		if substep["type"] == RecipeStepType.ADD_SPICE and substep["spice_id"] == spice_id:
			correct_step()
		else:
			incorrect_step()
	else:
		incorrect_step()

func _on_timer_finished():
	recipe_failed.emit()

func correct_step():
	print("correct!")
	
	if recipe[completed_steps]["type"] == RecipeStepType.ADD_SPICE:
		completed_normal_steps += 1
	completed_steps += 1
	step_completed.emit(completed_normal_steps)
	
	if completed_steps == len(recipe):
		recipe_completed.emit()
		return
	
	if recipe[completed_steps]["type"] == RecipeStepType.DISRUPTION_STEP:
		update_disruption.emit(recipe[completed_steps]["disruption_id"])
	else:
		update_disruption.emit(0)
	
func incorrect_step():
	print("incorrect :(")
	# TODO: decrease timer on failed ingredient

func _process(_delta):
	display_timer()

func display_timer():
	var secondsleft = int(floor(timer_child.time_left))
	var minutes = secondsleft / 60
	var seconds = secondsleft % 60
	label_child.text = "%02d:%02d" % [minutes,seconds]

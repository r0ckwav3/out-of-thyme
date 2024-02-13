extends Button

var recipe_title_cfg

# Called when the node enters the scene tree for the first time.
func _ready():
	var json = load("res://Data/recipe_title_cfg.json")
	recipe_title_cfg = json.data
	text = generate_title()

func _on_button_pressed():
	text = generate_title()

func generate_title():
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

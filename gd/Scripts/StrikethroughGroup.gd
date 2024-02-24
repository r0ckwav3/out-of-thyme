extends Node2D

@export var strikethrough: PackedScene
@export var spacing = 100
var st_counter = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_strikethrough():
	var st = strikethrough.instantiate()
	st.position.x = 0
	st.position.y = st_counter * spacing
	add_child(st)
	st_counter+=1

func remove_strikethrough():
	var st = get_child(st_counter-1)
	remove_child(st)
	st.queue_free()
	st_counter-=1
	
func set_num_strikethroughs(n):
	while st_counter < n:
		add_strikethrough()
	while st_counter > n:
		remove_strikethrough()

extends Sprite2D


@export var state : int
# States:
# 0: regular
# 1: overboiling
# 2: green
# 3: red
@export var bubble_obj : PackedScene
@export_group("Bubble Spawn Parameters") 
@export var bubble_spawn_offset : float
@export var bubble_spawn_width : float
@export var bubble_spawn_height : float
@export var bubble_delay_min = 0.1
@export var bubble_delay_max = 0.5 
@export_group("State Parameters") 
@export var overboil_multiplier = 0.1

var bubble_cooldown = 0;

func _ready():
	print("test")

func _process(delta):
	bubble_cooldown -= delta;
	if bubble_cooldown < 0:
		if state == 1:
			bubble_cooldown = randf_range(bubble_delay_min, bubble_delay_max) * overboil_multiplier 
		else:
			bubble_cooldown = randf_range(bubble_delay_min, bubble_delay_max)
			
		_create_bubble()
	
func _create_bubble():
	# select a point and then apply transformation from square to diamond
	# 0,0 is bottom, 1,0 is left, 0,1 is right, 1,1 is top
	if state != 1:
		var bubble = bubble_obj.instantiate()
		bubble.position = _calc_bubble_pos(randf(), randf())
		add_child(bubble)
	else:
		# to make overboiling look good, spawn one bubble per quadrant

		var bubble1 = bubble_obj.instantiate()
		bubble1.position = _calc_bubble_pos(randf()*0.5, randf()*0.5)
		add_child(bubble1)
		var bubble2 = bubble_obj.instantiate()
		bubble2.position = _calc_bubble_pos(0.5 + randf()*0.5, randf()*0.5)
		add_child(bubble2)
		var bubble3 = bubble_obj.instantiate()
		bubble3.position = _calc_bubble_pos(randf()*0.5, 0.5 + randf()*0.5)
		add_child(bubble3)
		var bubble4 = bubble_obj.instantiate()
		bubble4.position = _calc_bubble_pos(0.5 + randf()*0.5, 0.5 + randf()*0.5)
		add_child(bubble4)

func _calc_bubble_pos(dim1, dim2):
	var base = Vector2(0, bubble_spawn_offset-(bubble_spawn_height/2))
	return base + dim1 * Vector2(-bubble_spawn_width/2, bubble_spawn_height/2) + dim2 * Vector2(bubble_spawn_width/2, bubble_spawn_height/2)

# this should really be done in an animation manager
func set_state(new_state):
	# reset stuff from last state
	if state == 2:
		self_modulate.r = 1.0
	if state == 3:
		self_modulate.g = 1.0
	
	# setup new state
	if new_state == 2:
		self_modulate.r = 0.0
	if new_state == 3:
		self_modulate.g = 0.0
	
	state = new_state

extends Sprite2D


@export var state : int
# States:
# 0: regular
# 1: overboiling
# 2: green
# 3: black

@export var bubble_obj : PackedScene
@export_category("Bubble Spawn Parameters") 
@export var bubble_spawn_offset : float
@export var bubble_spawn_width : float
@export var bubble_spawn_height : float
@export var bubble_delay_min = 0.1
@export var bubble_delay_max = 0.5 

var bubble_cooldown = 0;

func _process(delta):
	bubble_cooldown -= delta;
	if bubble_cooldown < 0:
		bubble_cooldown = randf_range(bubble_delay_min, bubble_delay_max)
		_create_bubble()
	
func _create_bubble():
	var bubble = bubble_obj.instantiate()
	# select a point and then apply transformation from square to diamond
	# 0,0 is bottom, 1,0 is left, 0,1 is right, 1,1 is top
	var base = Vector2(0, bubble_spawn_offset-(bubble_spawn_height/2))
	var dim1 = randf() * Vector2(-bubble_spawn_width/2, bubble_spawn_height/2)
	var dim2 = randf() * Vector2(bubble_spawn_width/2, bubble_spawn_height/2)
	bubble.position = base + dim1 + dim2
	add_child(bubble)
	

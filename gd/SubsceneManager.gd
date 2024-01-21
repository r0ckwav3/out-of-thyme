extends Node2D

signal began_scene_transition(from_scene_id)
signal finished_scene_transition(to_scene_id)

var subscenes = []
@export var currsubscene = 0
@export var transition_time = 0.5 #seconds
@export var min_speed = 1000 # transition time is always smaller than dist/minspeed
var movement_state = MovementState.REST
var curroffset = 0

var true_transition_time
var transition_timer
var screenwidth # I'm using keep_width, so this won't change if the window size changes
var movestart


enum MovementState{
	REST,
	MOVING,
}
	

# Called when the node enters the scene tree for the first time.
func _ready():
	screenwidth = get_tree().root.get_visible_rect().size.x
	#screenwidth = 100
	
	for c in get_children():
		if c is Node2D:
			c.visible = false
			c.position = Vector2(screenwidth * len(subscenes), 0)
			subscenes.append(c)
	subscenes[currsubscene].visible = true
	
	position.x = -screenwidth * currsubscene


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var target_x = -screenwidth * currsubscene
	if movement_state == MovementState.MOVING:
		transition_timer += delta
		if transition_timer >= true_transition_time:
			finished_scene_transition.emit(currsubscene)
			position.x = target_x
			movement_state = MovementState.REST
			for i in range(len(subscenes)):
				if i != currsubscene:
					subscenes[i].visible = false
		else:
			var t = transition_timer/true_transition_time
			var relative_pos = -2*(t**3) + 3*(t**2)
			var real_pos = movestart + relative_pos*(target_x-movestart)
			position.x = real_pos

func change_target(subscene_id):
	if currsubscene != subscene_id:
		began_scene_transition.emit(currsubscene)
		currsubscene = subscene_id
		movestart = position.x
		true_transition_time = min(transition_time, abs(movestart - (-screenwidth * currsubscene))/min_speed)
		transition_timer = 0
		if movement_state == MovementState.REST:
			movement_state = MovementState.MOVING
			for c in subscenes:
				c.visible = true

func _input(event):
	if event.is_action_pressed("ui_left"):
		var nextsubscene = currsubscene - 1
		if nextsubscene < 0:
			nextsubscene = len(subscenes)-1
		change_target(nextsubscene)
	if event.is_action_pressed("ui_right"):
		var nextsubscene = currsubscene + 1
		if nextsubscene >= len(subscenes):
			nextsubscene = 0
		change_target(nextsubscene)

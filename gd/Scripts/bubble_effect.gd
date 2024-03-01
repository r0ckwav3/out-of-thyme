extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	get_child(0).play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	queue_free()

extends Sprite2D

var speed = 2000
var vel = Vector2(0.6,0.8)


func _init():
	pass
	
func _process(delta):
	DisplayServer.window_get_size()
	position += vel * speed * delta
	var screensize = get_tree().root.get_visible_rect().size
	
	if position.x < 0:
		position.x = 0
		vel.x = -vel.x
	if position.x > screensize.x:
		position.x = screensize.x
		vel.x = -vel.x
	
	if position.y < 0:
		position.y = 0
		vel.y = -vel.y
	if position.y > screensize.y:
		position.y = screensize.y
		vel.y = -vel.y
	
	

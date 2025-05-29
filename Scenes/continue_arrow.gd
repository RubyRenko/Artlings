extends Sprite2D

var max_up = position.y + 2
var max_down = position.y -2
var movement = 0.02

func _process(_delta):
	position.y += movement
	if position.y >= max_up:
		movement = -movement
	elif position.y <= max_down:
		movement = abs(movement)

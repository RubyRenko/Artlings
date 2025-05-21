extends Label

var max_up = 588
var max_down = 582
var movement = 0.02

func _ready():
	print(position.y)
func _process(_delta):
	position.y += movement
	if position.y >= max_up:
		movement = -movement
	elif position.y <= max_down:
		movement = abs(movement)

extends Node2D

@onready var can_learn = []

func _ready():
	var move1 = Move.new()
	move1.set_stats(10, 100, "Normal", "Basic Attack")
	can_learn.append(move1)
	
	var move2 = Move.new()
	move2.set_stats(50, 80, "Normal", "Reckless Charge")
	can_learn.append(move2)
	
	var move3 = Move.new()
	move3.set_stats(30, 90, "Normal", "Smart Strike")
	can_learn.append(move3)
	print(can_learn)

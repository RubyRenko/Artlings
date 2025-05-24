extends Node3D

@onready var trainer1 = $Trainer1

func _ready():
	trainer1.get_child(0).add_experience(100)
	trainer1.get_child(0).add_experience(100)

func get_trainer(name):
	for trainer in get_children():
		if trainer.name == name:
			return trainer.get_children()

func get_random():
	var rand = randi_range(0, get_child_count()-1)
	return get_child(rand).get_children()

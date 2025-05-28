extends Node3D

func hide_children():
	for child in get_children():
		if child.visible:
			child.visible = false

func get_trainer(name):
	for trainer in get_children():
		if trainer.name == name:
			return trainer

func get_random():
	var rand = randi_range(0, get_child_count()-1)
	return get_child(rand)

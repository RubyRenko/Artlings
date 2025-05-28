extends Node3D

func _ready():
	for trainer in get_children():
		trainer.setup_artlings()

func get_next_trainer():
	for trainer in get_children():
		if !trainer.defeated:
			return trainer

func get_trainer(name):
	for trainer in get_children():
		if trainer.name == name:
			return trainer

func get_random():
	var rand = randi_range(0, get_child_count()-1)
	return get_child(rand)

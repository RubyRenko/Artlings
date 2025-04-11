extends Node

func get_move(move):
	for i in range(get_child_count()):
		if get_child(i).name == move:
			return get_child(i)

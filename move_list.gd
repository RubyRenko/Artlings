extends Node

func get_move(move):
	# get the move based on the name
	for i in range(get_child_count()):
		if get_child(i).name == move:
			return get_child(i)

func print_all_moves():
	for move in get_children():
		print(move)
		print("")

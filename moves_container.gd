extends GridContainer

func load_possible_moves(move_list):
	for i in get_child_count():
		var move_opt = get_child(i)
		for move in move_list:
			move_opt.add_item(move)
		if i >= len(move_list):
			move_opt.selected = -1
		else:
			move_opt.selected = i

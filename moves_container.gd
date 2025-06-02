extends GridContainer

@onready var move1_button = $Move1
func load_possible_moves(current_moves, all_moves):
	for i in 4:
		var move_opt = get_child(i)
		move_opt.clear()
		for move in all_moves:
			move_opt.add_item(move)
		#move1_button.set_button_mask(MOUSE_BUTTON_MASK_LEFT)
		if len(all_moves) > 4:
			move_opt.set_button_mask(MOUSE_BUTTON_MASK_LEFT)
		
		if i < len(current_moves):
			move_opt.select(all_moves.find(current_moves[i]))
			move_opt.disabled = false
		else:
			move_opt.select(-1)
			move_opt.disabled = true
		
	"if len(all_moves) > 4:
		print(current_moves)
		for i in get_child_count():
			var move_opt = get_child(i)
			move_opt.clear()
			for move in all_moves:
				move_opt.add_item(move)
			move_opt.select(all_moves.find(current_moves[i]))
			move_opt.disabled = false
			move1_button.get_popup().visible = true
	else:
		print(current_moves)
		for i in get_child_count():
			var move_opt = get_child(i)
			move_opt.get_popup().visible = false
			if i >= len(current_moves):
				move_opt.selected = -1
				move_opt.disabled = true
			else:
				if move_opt.has_selectable_items():
					move_opt.select(0)
				else:
					move_opt.add_item(current_moves[i])
				move_opt.disabled = false"

	"if len(current_moves) >= 4:
		for i in get_child_count():
			var move_opt = get_child(i)
			move_opt.clear()
			for move in all_moves:
				move_opt.add_item(move)
			if i >= len(current_moves):
				move_opt.selected = -1
				move_opt.disabled = true
			else:
				move_opt.select(all_moves.find(current_moves[i]))
				move_opt.disabled = false
	else:
		for i in get_child_count():
			var move_opt = get_child(i)
			move_opt.clear()
			if i >= len(current_moves):
				move_opt.selected = -1
				move_opt.disabled = true
			else:
				move_opt.add_item(current_moves[i])
				move_opt.select(0)
				move_opt.disabled = false"

func get_current_move_names():
	var selected_moves = []
	for move in get_children():
		if move.selected != -1:
			selected_moves.append(move.get_item_text(move.selected))
	return selected_moves

extends HBoxContainer

var choosable_moves = []

func toggle_move_buttons(moves):
	if moves != null:
		var i = 0
		for move in moves:
			var move_button = get_child(i)
			#get_child(i).name = move
			move_button.set_text(move)
			move_button.disabled = false
			choosable_moves.append(move)
			i += 1
		while i < 4:
			var move_button = get_child(i)
			move_button.disabled = true
			i += 1

func disable_buttons():
	for child in get_children():
		child.disabled = true

func get_move_text(ind):
	return get_child(ind).text

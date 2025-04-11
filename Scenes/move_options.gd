extends HBoxContainer

var choosable_moves = []

func load_moves(moves):
	var i = 0
	for move in moves:
		get_child(i).name == move
		get_child(i).set_text(move)
		get_child(i).disabled = false
		choosable_moves.append(move)
		i += 1
	while i < 4:
		get_child(i).disabled = true
		i += 1

func disable_buttons():
	for child in get_children():
		child.disabled = true

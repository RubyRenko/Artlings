extends HBoxContainer

var choosable_moves = []

func toggle_move_buttons(moves):
	#print(moves)
	for i in range(get_child_count()):
		var move_button = get_child(i)
		if i < len(moves):
			move_button.get_child(0).text = moves[i].capitalize()
			move_button.disabled = false
			choosable_moves.append(moves[i])
			i += 1
		elif i >= len(moves):
			move_button.get_child(0).text = "None"
			move_button.disabled = true
			i += 1

func disable_buttons():
	for child in get_children():
		child.disabled = true

func enable_buttons(ind):
	for i in ind:
		get_child(i).disabled = false

func get_move_text(ind):
	return get_child(ind).text

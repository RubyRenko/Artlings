extends VBoxContainer

func toggle_party_buttons(team_list):
	for i in get_child_count():
		var button = get_child(i)
		if i >= len(team_list):
			button.visible = false
		else:
			button.visible = true
			button.set_text(team_list[i].name)
		

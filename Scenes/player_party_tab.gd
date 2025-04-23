extends VBoxContainer

func toggle_party_buttons(team_list):
	# for each button in the possible team list
	for i in get_child_count():
		var button = get_child(i)
		# if going off the end of the team list, sets the button to not visible
		if i >= len(team_list):
			button.visible = false
		# otherise, sets the button to visible and make the text
		# makes the button text show the corresponding team member
		else:
			button.visible = true
			button.set_text(team_list[i].name)

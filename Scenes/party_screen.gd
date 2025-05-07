extends Panel
@onready var party_list = $Artlings

func toggle_party_buttons(team_list):
	# for each button in the possible team list
	for i in 6:
		var button = party_list.get_child(i)
		var button_label = button.get_child(0)
		# if going off the end of the team list, sets the button to not visible
		if i == len(team_list):
			button.visible = false
		elif i > len(team_list):
			button.visible = false
		# otherise, sets the button to visible and make the text
		# makes the button text show the corresponding team member
		else:
			button.visible = true
			button.set_button_icon(team_list[i].img)
			button_label.set_text(team_list[i].nickname + " | Level " + str(team_list[i].level) )

extends Panel
@onready var party_list = $Artlings
@onready var toggle_list = $Artlings2

func toggle_party_buttons(team_list):
	# for each button in the possible team list
	for i in 6:
		var button = party_list.get_child(i)
		var button_label = button.get_child(0)
		# if going off the end of the team list, sets the button to not visible
		if i >= len(team_list):
			button.visible = false
		# otherise, sets the button to visible and make the text
		# makes the button text show the corresponding team member
		else:
			button.visible = true
			button.set_button_icon(team_list[i].img)
			button_label.set_text(team_list[i].nickname + " | Level " + str(team_list[i].level) )
	disable_swapping_buttons()

func disable_swapping_buttons():
	for button in toggle_list.get_children():
		button.visible = false

func toggle_swapping_buttons():
	for i in 6:
		var button = party_list.get_child(i)
		var swap_button = toggle_list.get_child(i)
		if button.disabled:
			swap_button.visible = !swap_button.visible
		else:
			swap_button.visible = !swap_button.visible

func _on_swap_button_pressed():
	toggle_swapping_buttons()

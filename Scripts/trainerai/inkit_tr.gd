extends Trainer

func choose_move(player_mon, current_mon):
	if player_mon.status == "None":
		return ["Smoke", "Stipple"].pick_random()
	elif player_mon.defense <= player_mon.mind:
		return "InkSlash"
	else:
		return ["Dollop", "Stippple"].pick_random()
	

extends Trainer

func choose_move(player_mon, current_mon):
	if current_mon.status != "None":
		return "Inkblot"
	elif player_mon.status == "None":
		return "Smoke"
	else:
		return "Stipple"
	

extends Trainer

func choose_move(player_mon, current_mon):
	if current_mon.nickname == "Inkit":
		if current_mon.status != "None":
			return "Inkblot"
		elif player_mon.status == "None":
			return "Smoke"
		else:
			return "Stipple"
	else:
		if current_mon.status == "None":
			return "Focus"
		elif current_mon.status == "Focusing":
			return "Charge"
		else:
			return ["Teeth", "Blender"].pick_random()

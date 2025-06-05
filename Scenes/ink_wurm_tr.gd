extends Trainer

func choose_move(player_mon, current_mon):
	if current_mon.species == "Inkit":
		if current_mon.status != "None":
			return "Inkblot"
		elif player_mon.status == "None":
			return "Smoke"
		else:
			return "Stipple"
	elif current_mon.species == "Wurm":
		if current_mon.status == "None":
			return "Focus"
		elif current_mon.status == "Focusing":
			return "Charge"
		else:
			return ["Teeth", "Blender"].pick_random()

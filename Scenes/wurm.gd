extends Trainer

func choose_move(player_mon, current_mon):
	if current_mon.status == "None":
		return "Focus"
	else:
		return ["Teeth", "Charge"].pick_random()

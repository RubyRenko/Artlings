extends Trainer

func choose_move(player_mon, current_mon):
	print(current_mon.status)
	if current_mon.status == "None":
		return "Focus"
	elif current_mon.status == "Focusing":
		return "Charge"
	else:
		return "Teeth"

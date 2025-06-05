extends Trainer

func choose_move(player_mon, current_mon):
	if current_mon.health <= current_mon.max_hp/2:
		return ["Cure", "Sap"].pick_random()
	elif current_mon.status != "None":
		return "Cure"
	elif player_mon.status == "None":
		return ["Wash", "BubbleBurst"].pick_random()
	else:
		return ["Sap", "BubbleBurst"].pick_random()

extends Trainer

func choose_move(player_mon, current_mon):
	if current_mon.health <= current_mon.max_hp/2:
		return ["Rejuvenate", "Sap"].pick_random()
	elif player_mon.status == "None":
		return "Wash"
	elif current_mon.status == "None":
		return "Bubble"
	else:
		return "Sap"

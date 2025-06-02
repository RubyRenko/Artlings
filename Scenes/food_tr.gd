extends Trainer

func choose_move(player_mon, current_mon):
	if current_mon.species == "Bapig":
		if current_mon.health >= 10:
			#print("High health, using bacon slap")
			return "BaconSlap"
		else:
			#print("Low health, using other move")
			return ["Thud", "Lick"].pick_random()
	elif current_mon.species == "Yolkcub":
		if player_mon.status == "None":
			return "Roll"
		elif current_mon.status == "None":
			return "Focus"
		elif current_mon.health <= current_mon.max_hp/2:
			return "Nibble"
		else:
			return ["Nibble", "Charge"].pick_random()

extends Trainer

func choose_move(player_mon, current_mon):
	if current_mon.species == "Bapig":
		if current_mon.health >= 10:
			print("High health, using bacon slap")
			return "BaconSlap"
		else:
			print("Low health, using other move")
			return ["Thud", "Lick"].pick_random()
	elif current_mon.species == "Yolkcub":
		return current_mon.current_moves.pick_random()

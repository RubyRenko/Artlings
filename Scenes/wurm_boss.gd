extends Trainer

func choose_move(player_mon, current_mon):
	if player_mon.status == "None":
		return "Grapple"
	elif current_mon.health >= current_mon.max_hp/3:
		return "TeethShot"
	elif player_mon.defense < player_mon.mind:
		return "Blender"
	else:
		return "Screech"

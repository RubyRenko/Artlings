extends Control

func _ready():
	$PartyScreen.toggle_party_buttons($Player.team)
	$PartyScreen.disable_buttons()

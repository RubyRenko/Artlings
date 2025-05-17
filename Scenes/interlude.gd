extends Control

# screens
@onready var create_screen = $CreateScreen
@onready var party_screen = $PartyScreen

# buttons
@onready var party_button = $PartyButton
@onready var create_button = $CreateButton
@onready var index_button = $IndexButton
@onready var next_button = $NextBattleButton

@onready var player = get_parent()

func _on_party_button_pressed():
	hide_screens()
	party_screen.visible = true
	party_screen.toggle_party_buttons(player.team)

func hide_screens():
	create_screen.visible = false
	party_screen.visible = false
	for mon in player.team:
		mon.stat_screen.visible = false

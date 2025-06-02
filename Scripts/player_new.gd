extends CharacterBody3D

@onready var gravity = -ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var team_node = $Artlings
@onready var party_screen = $PartyScreen
@onready var create_screen = $CreateScreen
@onready var party_button = $PartyButton
@onready var create_button = $CreateButton
@onready var artlings_list = ArtlingsMasterlist.new()

var speed = 150.0
var jump = false
var can_move = true
var battling = false
var leader

static var team = []
var inspo = 0

func _ready():
	# adds the 3 starters to the team
	team_node.add_teammate("Inkit")
	team_node.add_teammate("Dewphin")
	team_node.add_teammate("Wurm")
	party_screen.visible = false
	create_screen.visible = false
	leader = team[0]
	leader.visible = true
	leader.play_idle_anim()
	#inspo += 6
	#print("current team")
	#print(team)

func load_team():
	# updates team based off the children in teamnode and updates party_tab
	team = team_node.get_children()
	party_screen.toggle_party_buttons(team)

func _on_artling_1_pressed():
	show_artling(0)

func _on_artling_2_pressed():
	show_artling(1)

func _on_artling_3_pressed():
	show_artling(2)

func _on_artling_4_pressed():
	show_artling(3)

func _on_artling_5_pressed():
	show_artling(4)

func _on_artling_6_pressed():
	show_artling(5)

func show_artling(ind):
	# if the stat screen is currently visible
	if team[ind].stat_screen.visible:
		# hides stat screen, updates values, and lets player move again
		team[ind].stat_screen.visible = false
		can_move = true
		team[ind].update_from_stat_screen()
	# if the stat screen isn't visible
	else:
		# hides other stat screens and makes sure stat screen is up to date
		# shows stat screen and disables movement
		hide_screens()
		team[ind].setup_stat_screen()
		team[ind].stat_screen.visible = true
		can_move = false

func hide_screens():
	# for every teammate, hides the stat screen if it's visible
	for teammate in team:
		if teammate.stat_screen.visible == true:
			teammate.stat_screen.visible = false
			teammate.update_from_stat_screen()
	if party_screen.visible:
		party_screen.visible = false
	if create_screen.visible:
		create_screen.visible = false

func cycle_team():
	team.append(team[0])
	team[0].visible = false
	team[0] = team.pop_at(1)
	party_screen.toggle_party_buttons(team)
	leader = team[0]

func toggle_party_screen():
	party_screen.toggle_party_buttons(team)
	if party_screen.visible == true:
		hide_screens()
		if !battling:
			can_move = true
	else:
		hide_screens()
		party_screen.visible = true
		can_move = false

func _on_party_button_pressed():
	toggle_party_screen()

func _on_create_artling_pressed():
	if inspo < 2:
		create_screen.create_button.set_text("Not enough inspiration")
	elif len(team) >= 6:
		create_screen.create_button.set_text("Team is full!")
	elif inspo >= 2:
		if create_screen.new_artling_name == "":
			team_node.add_teammate(create_screen.calculate_artling())
		elif create_screen.new_artling_name != "":
			var nickname = create_screen.new_artling_name
			team_node.add_teammate(create_screen.calculate_artling(), nickname)
		inspo -= 2

func _on_create_button_pressed():
	create_screen.setup_screen()
	if create_screen.visible == true:
		hide_screens()
		if !battling:
			can_move = true
	else:
		hide_screens()
		create_screen.visible = true
		can_move = false

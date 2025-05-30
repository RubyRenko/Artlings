extends Node3D

@onready var team_node = $Artlings
var team = []
var inspo = 0

@onready var interlude_bg = $Bg
@onready var party_screen = $Bg/PartyScreen
@onready var stat_screen_bg = $Bg/PartyScreen/StatScreenBg
@onready var create_screen = $Bg/CreateScreen
@onready var naming_screen = $Bg/CreateScreen/NameScreen
@onready var index_screen = $Bg/IndexScreen

@onready var party_button = $Bg/PartyButton
@onready var create_button = $Bg/CreateButton
@onready var index_button = $Bg/IndexButton
@onready var next_button = $Bg/NextBattleButton

var swapping = []
var artling_shown : int

func _ready():
	add_artling("Inkit")
	add_artling("Dewphin")
	add_artling("Wurm")
	hide_screens()
	
	for i in 6:
		var artling_button = party_screen.party_list.get_child(i)
		var artling_callable = Callable(self, "_on_artling_pressed").bind(i)
		artling_button.connect("pressed", artling_callable)
		
		var swap_button = party_screen.toggle_list.get_child(i)
		var swap_callable = Callable(self, "_on_swap_pressed").bind(i)
		swap_button.connect("pressed", swap_callable)

func load_team():
	# updates team based off the children in teamnode and updates party_tab
	team = team_node.get_children()

func swap_team(ind1, ind2):
	var artling1 = team[ind1]
	var artling2 = team[ind2]
	team[ind1] = artling2
	team[ind2] = artling1

func hide_screens(true_hide = false):
	if true_hide:
		interlude_bg.visible = false
	else:
		party_screen.visible = false
		create_screen.visible = false
		index_screen.visible = false
		for artling in team:
			artling.stat_screen.visible = false

func show_party_screen():
	party_screen.visible = true
	stat_screen_bg.visible = false
	party_screen.toggle_party_buttons(team)

func show_create_screen():
	create_screen.visible = true
	naming_screen.visible = false
	create_screen.setup_screen()

func show_index_screen():
	index_screen.visible = true
	index_screen.setup_index()

func _on_create_artling_pressed():
	if inspo >= create_screen.inspo_cost:
		var new_artling = create_screen.calculate_artling()
		add_artling(new_artling)
		naming_screen.visible = true
		naming_screen.setup_confirm(team[-1])
		inspo -= create_screen.inspo_cost

func _on_confirm_name_pressed():
	team[-1].nickname = naming_screen.nickname.text
	hide_screens()

func show_artling(ind):
	team[ind].update_stat_screen()
	team[ind].stat_screen.visible = true

func remove_artling(artling):
	if artling == "all":
		team_node.remove_all()
	elif typeof(artling) == typeof(1):
		team_node.remove_artling(artling)

func add_artling(artling_name, nickname = artling_name):
	if !(artling_name in index_screen.artlings_discovered):
		print("added artling ", artling_name)
		index_screen.artlings_discovered.append(artling_name)
	team_node.add_teammate(artling_name, nickname)
	load_team()

func _on_party_button_pressed():
	hide_screens()
	show_party_screen()

func _on_create_button_pressed():
	hide_screens()
	show_create_screen()

func _on_index_button_pressed():
	hide_screens()
	show_index_screen()

func _on_back_button_pressed():
	hide_screens()

func _on_exit_stat_screen_pressed():
	team[artling_shown].update_from_stat_screen()
	team[artling_shown].stat_screen.visible = false
	stat_screen_bg.visible = false

func _on_artling_pressed(index):
	stat_screen_bg.visible = true
	show_artling(index)
	artling_shown = index

func _on_swap_pressed(index):
	swapping.append(index)
	#print(swapping)
	if len(swapping) == 2:
		swap_team(swapping[0], swapping[1])
		party_screen.toggle_party_buttons(team)
		swapping = []

"func _on_artling_1_pressed():
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
	show_artling(5)"

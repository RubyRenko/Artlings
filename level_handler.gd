extends Node3D

@onready var tutorial = preload("res://Battlefields/tutorial.tscn")
@onready var battlefields = [
	preload("res://Battlefields/battlefield_1.tscn"), 
	preload("res://Battlefields/battlefield_2.tscn")]
@onready var current_battlefield
@onready var player = $Player
@onready var enemies = $Trainers
@onready var wild_battles = $WildBattles
@onready var environment_node = $Environment

#Choosing starter variables
@onready var choosing_starter = $ChooseStarter
@onready var starter_screen = $ChooseStarter/ChoosingScreen
@onready var confirm_screen = $ChooseStarter/ConfirmScreen
@onready var confirm_text = $ChooseStarter/ConfirmScreen/ConfirmText
@onready var starter_name = $ChooseStarter/ConfirmScreen/StarterName
@onready var starter_img = $ChooseStarter/ConfirmScreen/StarterImg

var starter : String
var starter_imgs = {
	"Inkit": preload("res://Assets/artlings/Inkit_Party_Screen.png"),
	"Dewphin": preload("res://Assets/artlings/Dewphy_Party_Screen_Export.png"),
	"Wurm": preload("res://Assets/artlings/wormCropped.png")
}
@onready var master_move_list = load("res://move_list.tscn").instantiate()

var in_tutorial = true
@onready var win_screen = $WinScreen

func _ready():
	choosing_starter.visible = false
	player.hide_screens(true)
	player.setup_player()
	current_battlefield = tutorial.instantiate()
	environment_node.add_child(current_battlefield)
	var tutorial_trainer = wild_battles.get_trainer("Tutorial")
	tutorial_trainer.visible = true
	current_battlefield.start_battle(player, tutorial_trainer)
	#master_move_list.print_all_moves()

func _on_environment_child_exiting_tree(node):
	#print(node)
	#print(node.is_in_group("boss"))
	if node.is_in_group("tutorial"):
		choosing_starter.visible = true
		player.remove_artling("all")
		player.inspo = 0
		wild_battles.hide_children()
		in_tutorial = false
	elif node.is_in_group("boss") && enemies.get_child(enemies.get_child_count()-1).defeated:
		player.interlude_bg.visible = true
		player.party_screen.visible = true
		player.party_screen.toggle_party_buttons(player.team)
		player.party_screen.disable_buttons()
		win_screen.visible = true
		#wild_battles.hide_children()
		enemies.get_child(enemies.get_child_count()-1).defeated = false
		player.next_button.get_child(0).set_text("Replay Boss?")
	elif node.is_in_group("battle"):
		player.interlude_bg.visible = true
		#wild_battles.hide_children()

func _on_next_battle_button_pressed():
	player.hide_screens(true)
	var opponent = enemies.get_next_trainer()
	for mon in opponent.team:
		if !(mon.species in player.index_screen.artlings_discovered):
			player.index_screen.artlings_discovered.append(mon.species)
	opponent.visible = true
	current_battlefield = opponent.battlefield.instantiate()
	environment_node.add_child(current_battlefield)
	if opponent == enemies.get_trainer("WurmBoss"):
		current_battlefield.add_to_group("boss")
	current_battlefield.start_battle(player, opponent)

func _on_train_button_pressed():
	player.hide_screens(true)
	current_battlefield = battlefields.pick_random().instantiate()
	environment_node.add_child(current_battlefield)
	var wild_battle
	if player.team[0].level <= 3:
		wild_battle = wild_battles.get_random(2)
	else:
		wild_battle = wild_battles.get_random()
	wild_battle.visible = true
	for mon in wild_battle.get_children():
		if !(mon.species in player.index_screen.artlings_discovered):
			player.index_screen.artlings_discovered.append(mon.species)
	current_battlefield.start_battle(player, wild_battle)

func _on_inkit_button_pressed():
	starter = "Inkit"
	starter_screen.visible = false
	confirm_screen.visible = true
	confirm_text.text = "Choosing " + starter + "?"
	starter_img.texture = starter_imgs[starter]

func _on_dewphin_button_pressed():
	starter = "Dewphin"
	starter_screen.visible = false
	confirm_screen.visible = true
	confirm_text.text = "Choosing " + starter + "?"
	starter_img.texture = starter_imgs[starter]

func _on_wurm_button_pressed():
	starter = "Wurm"
	starter_screen.visible = false
	confirm_screen.visible = true
	confirm_text.text = "Choosing " + starter + "?"
	starter_img.texture = starter_imgs[starter]

func _on_confirm_button_pressed():
	if starter_name.text != "":
		var nickname = starter_name.text
		player.add_artling(starter, nickname)
	else:
		player.add_artling(starter)
	choosing_starter.visible = false
	player.interlude_bg.visible = true

func _on_back_button_pressed():
	starter_name.text = ""
	starter_screen.visible = true
	confirm_screen.visible = false

func _on_encylo_back_button_pressed():
	player.hide_screens()


func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://Menus/title_screen.tscn")

func _on_credits_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/credits.tscn")

extends Node3D

@onready var tutorial = preload("res://Battlefields/tutorial.tscn")
@onready var battlefields = [
	preload("res://Battlefields/battlefield_1.tscn"), 
	preload("res://Battlefields/battlefield_2.tscn")]
@onready var current_battlefield
@onready var player = $Player
@onready var enemies = $Trainers
@onready var test_enemy = $Npc2
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
	"Inkit": preload("res://Assets/artlings/Inkit_IdlePose_Static.png"),
	"Dewphin": preload("res://Assets/water_starter_paper.jpg"),
	"Wurm": preload("res://Assets/wormCropped.png")
}

func _ready():
	choosing_starter.visible = false
	player.hide_screens(true)
	current_battlefield = battlefields[0].instantiate()
	environment_node.add_child(current_battlefield)
	current_battlefield.start_battle(player, enemies.get_trainer("Test4"))

func _on_environment_child_exiting_tree(node):
	#print(node)
	if node.is_in_group("tutorial"):
		choosing_starter.visible = true
		player.remove_artling("all")
		player.inspo = 0
	elif node.is_in_group("battle"):
		player.interlude_bg.visible = true

func _on_next_battle_button_pressed():
	player.hide_screens(true)
	current_battlefield = battlefields.pick_random().instantiate()
	environment_node.add_child(current_battlefield)
	current_battlefield.start_battle(player, enemies.get_random())

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

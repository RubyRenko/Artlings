extends Node3D

@onready var battlefields = [preload("res://Battlefields/battlefield_1.tscn"), preload("res://Battlefields/battlefield_2.tscn")]
@onready var current_battlefield
@onready var player = $Player
@onready var enemies = $Trainers
@onready var test_enemy = $Npc2
@onready var environment_node = $Environment

func _ready():
	player.hide_screens(true)
	current_battlefield = battlefields.pick_random().instantiate()
	environment_node.add_child(current_battlefield)
	current_battlefield.start_battle(player, enemies.get_random())

func _on_environment_child_exiting_tree(node):
	print(node)
	if node.is_in_group("battle"):
		player.interlude_bg.visible = true

func _on_next_battle_button_pressed():
	player.hide_screens(true)
	current_battlefield = battlefields.pick_random().instantiate()
	environment_node.add_child(current_battlefield)
	current_battlefield.start_battle(player, enemies.get_random())

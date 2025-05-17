extends Node3D

@onready var test_environment = preload("res://Battlefields/battlefield_1.tscn")
@onready var current_battlefield
@onready var player = $Player
@onready var test_enemy = $Npc2
@onready var environment_node = $Environment

func _ready():
	player.hide_screens(true)
	current_battlefield = test_environment.instantiate()
	environment_node.add_child(current_battlefield)
	current_battlefield.start_battle(player, [test_enemy.mon])

func _on_environment_child_exiting_tree(node):
	if node == current_battlefield:
		player.interlude_bg.visible = true

func _on_next_battle_button_pressed():
	player.hide_screens(true)
	current_battlefield = test_environment.instantiate()
	environment_node.add_child(current_battlefield)
	current_battlefield.start_battle(player, [test_enemy.mon])

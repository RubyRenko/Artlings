extends Node3D

@onready var test_environment = preload("res://Battlefields/battlefield_1.tscn")
@onready var player = $Player
@onready var test_enemy = $Npc2
@onready var environment_node = $Environment

func _ready():
	var new_environ = test_environment.instantiate()
	environment_node.add_child(new_environ)
	print(player.team[0].current_moves)
	new_environ.start_battle(player, [test_enemy.mon])

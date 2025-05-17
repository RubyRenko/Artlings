extends Node3D

@onready var battle_node = $BattleNew
var battling = true

func start_battle(player_mons, enemy_mons):
	battle_node.load_mons(player_mons, enemy_mons)

func _on_child_exiting_tree(node):
	if node == battle_node:
		queue_free()

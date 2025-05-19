extends Node3D

@onready var battle_node = $BattleNew

func start_battle(player_mons, enemy_mons):
	battle_node.player_spawn = $BattleNew/PlayerMarker
	battle_node.enemy_spawn = $BattleNew/EnemyMarker
	battle_node.load_mons(player_mons, enemy_mons)

func _on_child_exiting_tree(node):
	if node == battle_node:
		queue_free()

extends Node3D

@onready var battle_node = $BattleNew
@onready var player_marker = $BattleNew/PlayerMarker
@onready var enemy_marker = $BattleNew/EnemyMarker

func start_battle(player, enemy):
	if player_marker != null:
		battle_node.player_spawn = player_marker
	if enemy_marker != null:
		battle_node.enemy_spawn = enemy_marker
	battle_node.load_mons(player, enemy)

func _on_child_exiting_tree(node):
	if node == battle_node:
		queue_free()

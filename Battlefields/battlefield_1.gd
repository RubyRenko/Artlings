extends Node3D

@onready var battle_node = $BattleNew

func start_battle(player_mons, enemy_mons):
	battle_node.load_mons(player_mons, enemy_mons)

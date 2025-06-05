extends Node3D
class_name Trainer

@export var level : int
@export var artling_movesets = [ ["Move1", "Move2", "Move3", "Move4"] ]
@export var artling_stats = [ [5, 5, 5, 5, 5, 5] ]
@export var battlefield : PackedScene
@onready var team = get_children()
var defeated = false

func setup_artlings():
	for i in get_child_count():
		var artling = get_child(i)
		for move in artling_movesets[i]:
			artling.load_move(artling.master_move_list.get_move(move))
		artling.current_moves = artling_movesets[i]
		var stats = artling_stats[i]
		artling.set_stats(stats[0], stats[1], stats[2], stats[3], stats[4], stats[5])
		#print(artling.level)

func choose_move(player_mon, current_mon):
	return current_mon.current_moves.pick_random()

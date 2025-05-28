extends Node3D
class_name Trainer

@export var level : int
@export var artling_movesets = [ ["Move1", "Move2", "Move3", "Move4"] ]
@export var battlefield : PackedScene
var defeated = false

func setup_artlings():
	for i in get_child_count():
		var artling = get_child(i)
		artling.add_experience(100*level-1)
		artling.current_moves = artling_movesets[i]
		print(artling.level)

extends Control

@onready var stat_text = $Panel/Stats
@onready var name_text = $Panel/Name
@onready var level_text = $Panel/Level
@onready var moves_container = $Panel/MovesContainer
@onready var move1 = $Panel/MovesContainer/Move1
@onready var move2 = $Panel/MovesContainer/Move2
@onready var move3 = $Panel/MovesContainer/Move3
@onready var move4 = $Panel/MovesContainer/Move4
var chosen_moves : Array

func set_stat_text(hp, str, def, intel, mind, spd):
	stat_text.set_text("Health: %s\nStrength: %s\nDefense: %s\nIntelligence: %s\nMind: %s\nSpeed: %s" %
	 [hp, str, def, intel, mind, spd])

func set_name_text(artling_name):
	name_text.set_text(artling_name)

func set_level_text(level):
	level_text.set_text("Level %s" % level)
	chosen_moves = [
		move1.get_item_text(move1.selected),
		move2.get_item_text(move2.selected),
		move3.get_item_text(move3.selected),
		move4.get_item_text(move4.selected)]

func load_moves(move_list):
	moves_container.load_possible_moves(move_list)

func _on_move_1_item_selected(index):
	#print(move1.get_item_text(index))
	chosen_moves[0] = move1.get_item_text(index)
	print(chosen_moves)

func _on_move_2_item_selected(index):
	chosen_moves[1] = move2.get_item_text(index)
	print(chosen_moves)

func _on_move_3_item_selected(index):
	chosen_moves[2] = move3.get_item_text(index)
	print(chosen_moves)

func _on_move_4_item_selected(index):
	chosen_moves[3] = move4.get_item_text(index)
	print(chosen_moves)

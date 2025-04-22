extends Control

@onready var stat_text = $Panel/Stats
@onready var name_text = $Panel/Name
@onready var level_text = $Panel/Level
@onready var moves_container = $Panel/MovesContainer
@onready var move1 = $Panel/MovesContainer/Move1
@onready var move2 = $Panel/MovesContainer/Move2
@onready var move3 = $Panel/MovesContainer/Move3
@onready var move4 = $Panel/MovesContainer/Move4
@onready var move_desc = $Panel/MoveDesc
var chosen_moves : Array

func set_stat_text(hp, str, def, intel, mind, spd):
	stat_text.set_text("Health: %s\nStrength: %s\nDefense: %s\nIntelligence: %s\nMind: %s\nSpeed: %s" %
	 [hp, str, def, intel, mind, spd])

func set_name_text(artling_name):
	name_text.set_text(artling_name)

func set_level_text(level):
	level_text.set_text("Level %s" % level)

func load_moves(current_moves, all_moves):
	moves_container.load_possible_moves(current_moves, all_moves)
	chosen_moves = moves_container.get_current_move_names()

func _on_move_1_item_selected(index):
	#print(move1.get_item_text(index))
	chosen_moves[0] = move1.get_item_text(index)
	move_desc.text = str(get_parent().moves_list[chosen_moves[0]])
	print(chosen_moves)

func _on_move_2_item_selected(index):
	chosen_moves[1] = move2.get_item_text(index)
	move_desc.text = str(get_parent().moves_list[chosen_moves[1]])
	print(chosen_moves)

func _on_move_3_item_selected(index):
	chosen_moves[2] = move3.get_item_text(index)
	move_desc.text = str(get_parent().moves_list[chosen_moves[2]])
	print(chosen_moves)

func _on_move_4_item_selected(index):
	chosen_moves[3] = move4.get_item_text(index)
	move_desc.text = str(get_parent().moves_list[chosen_moves[3]])
	print(chosen_moves)

func _on_move_1_focus_entered():
	move_desc.text = str(get_parent().moves_list[chosen_moves[0]])

func _on_move_2_focus_entered():
	move_desc.text = str(get_parent().moves_list[chosen_moves[1]])

func _on_move_3_focus_entered():
	move_desc.text = str(get_parent().moves_list[chosen_moves[2]])

func _on_move_4_focus_entered():
	move_desc.text = str(get_parent().moves_list[chosen_moves[3]])

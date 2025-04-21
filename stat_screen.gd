extends Control

@onready var stat_text = $Panel/Stats
@onready var name_text = $Panel/Name
@onready var level_text = $Panel/Level
@onready var moves_container = $Panel/MovesContainer

"""func _ready():
	set_stat_text(10, 10, 10, 10, 10, 10)
	set_name_text("Example")
	set_level_text(1)
	moves_container.load_possible_moves(["Tackle", "Thud", "Bounce", "Fly", "Rip"])"""

func set_stat_text(hp, str, def, intel, mind, spd):
	stat_text.set_text("Health: %s\nStrength: %s\nDefense: %s\nIntelligence: %s\nMind: %s\nSpeed: %s" %
	 [hp, str, def, intel, mind, spd])

func set_name_text(artling_name):
	name_text.set_text(artling_name)

func set_level_text(level):
	level_text.set_text("Level %s" % level)

func load_moves(move_list):
	moves_container.load_possible_moves(move_list)

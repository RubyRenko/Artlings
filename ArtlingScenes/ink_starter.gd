extends Mon
@onready var hp_bar = $HpBar
@onready var stat_screen = $ArtlingStats

func _ready():
	learnable_moves = ["Brush", "Smoke", "Dollop", "InkSlash", "InkPool"]
	var moves = master_move_list.instantiate()
	load_move(moves.get_move("Brush"))
	load_move(moves.get_move("Smoke"))
	load_move(moves.get_move("Dollop"))
	load_move(moves.get_move("InkSlash"))
	load_move(moves.get_move("InkPool"))
	health = max_hp
	setup_stat_screen()

func _process(_delta):
	hp_bar.text = str(health) + " / " + str(max_hp)
	current_moves = stat_screen.chosen_moves

func setup_stat_screen():
	stat_screen.load_moves(moves_list.keys())
	stat_screen.set_name_text(name)
	stat_screen.set_level_text(level)
	stat_screen.set_stat_text(health, strength, defense, intelligence, mind, speed)

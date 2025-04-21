extends Mon
@onready var hp_bar = $HpBar
@onready var stat_screen = $ArtlingStats

func _ready():
	learnable_moves = ["Thud", "Charge", "Triangle"]
	var moves = master_move_list.instantiate()
	load_move(moves.get_move("Thud"))
	load_move(moves.get_move("Charge"))
	load_move(moves.get_move("Triangle"))
	health = max_hp
	setup_stat_screen()

func _process(delta):
	hp_bar.text = str(health) + " / " + str(max_hp)

func setup_stat_screen():
	stat_screen.load_moves(moves_list.keys())
	stat_screen.set_name_text(name)
	stat_screen.set_level_text(level)
	stat_screen.set_stat_text(health, strength, defense, intelligence, mind, speed)

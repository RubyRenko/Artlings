extends Mon
@onready var hp_bar = $HpBar
@onready var stat_screen = $ArtlingStats

func _ready():
	learnable_moves = ["Thud", "Charge", "Teeth", "Blender", "Lick"]
	load_move(master_move_list.get_move("Thud"))
	load_move(master_move_list.get_move("Charge"))
	#load_move(moves.get_move("Teeth"))
	#load_move(moves.get_move("Blender"))
	#load_move(moves.get_move("Lick"))
	health = max_hp
	setup_stat_screen()

func _process(_delta):
	hp_bar.text = str(health) + " / " + str(max_hp)
	current_moves = stat_screen.chosen_moves

func setup_stat_screen():
	stat_screen.load_moves(current_moves, moves_list.keys())
	stat_screen.set_name_text(name)
	stat_screen.set_level_text(level)
	stat_screen.set_stat_text(health, strength, defense, intelligence, mind, speed)

func update_from_stat_screen():
	current_moves = stat_screen.chosen_moves

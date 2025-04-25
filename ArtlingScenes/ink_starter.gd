extends Mon
@onready var hp_bar = $HpBar
@onready var stat_screen = $ArtlingStats
@onready var img = preload("res://Assets/InkStarterCropped.png")

func _ready():
	learnable_moves = ["Brush", "Smoke", "Dollop", "InkSlash", "InkPool"]
	load_move(master_move_list.get_move("Brush"))
	load_move(master_move_list.get_move("Smoke"))
	"""load_move(moves.get_move("Dollop"))
	load_move(moves.get_move("InkSlash"))
	load_move(moves.get_move("InkPool"))"""
	health = max_hp
	setup_stat_screen()

func _process(_delta):
	hp_bar.text = str(health) + " / " + str(max_hp)

func setup_stat_screen():
	stat_screen.load_moves(current_moves, moves_list.keys())
	stat_screen.set_name_text(name)
	stat_screen.set_level_text(level)
	stat_screen.set_stat_text(health, strength, defense, intelligence, mind, speed)
	stat_screen.set_img(img)

func update_from_stat_screen():
	current_moves = stat_screen.chosen_moves

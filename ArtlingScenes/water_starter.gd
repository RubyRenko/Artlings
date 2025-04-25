extends Mon
@onready var hp_bar = $HpBar
@onready var stat_screen = $ArtlingStats
@onready var img = preload("res://Assets/Watercolor_Starter_for_ExportCropped.png")

func _ready():
	learnable_moves = ["Thud", "Bubble", "Heal"]
	load_move(master_move_list.get_move("Thud"))
	load_move(master_move_list.get_move("Bubble"))
	load_move(master_move_list.get_move("Heal"))
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

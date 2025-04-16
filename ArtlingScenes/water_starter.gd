extends Mon
@onready var hp_bar = $HpBar

func _ready():
	learnable_moves = ["Thud", "Bubble", "Heal"]
	var moves = master_move_list.instantiate()
	load_move(moves.get_move("Thud"))
	load_move(moves.get_move("Bubble"))
	load_move(moves.get_move("Heal"))
	health = max_hp

func _process(delta):
	hp_bar.text = str(health) + " / " + str(max_hp)

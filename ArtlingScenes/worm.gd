extends Mon
@onready var hp_bar = $HpBar

func _ready():
	learnable_moves = ["Thud", "Charge", "Triangle"]
	var moves = master_move_list.instantiate()
	load_move(moves.get_move("Thud"))
	load_move(moves.get_move("Charge"))
	load_move(moves.get_move("Triangle"))
	health = max_hp
	print(moves_list)

func _process(delta):
	hp_bar.text = str(health) + " / " + str(max_hp)

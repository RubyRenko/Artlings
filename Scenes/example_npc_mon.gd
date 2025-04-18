extends Mon
@onready var hp_bar = $HpBar

func _ready():
	learnable_moves = ["Thud", "Firespit"]
	var moves = master_move_list.instantiate()
	load_move(moves.get_move("Thud"))
	load_move(moves.get_move("Firespit"))
	health = max_hp

func _process(delta):
	hp_bar.text = str(health) + " / " + str(max_hp)

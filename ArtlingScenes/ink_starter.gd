extends Mon
@onready var hp_bar = $HpBar

func _ready():
	learnable_moves = ["Smoke", "Dollop", "InkSlash"]
	var moves = master_move_list.instantiate()
	load_move(moves.get_move("Smoke"))
	load_move(moves.get_move("Dollop"))
	load_move(moves.get_move("InkSlash"))
	health = max_hp

func _process(delta):
	hp_bar.text = str(health) + " / " + str(max_hp)

extends Mon

func _ready():
	learnable_moves = ["Thud", "Charge", "Smoke", "Firespit"]
	var moves = master_move_list.instantiate()
	load_move(moves.get_move("Thud"))
	load_move(moves.get_move("Charge"))
	load_move(moves.get_move("Smoke"))
	load_move(moves.get_move("Firespit"))
	health = max_hp
	if level == 1:
		set_stats(base_hp, base_str, base_def, base_int, base_mnd, base_spd)
	$HpBar.max_value = max_hp
	print(moves_list)

func _process(delta):
	$HpBar.value = health

extends Mon

func _ready():
	learnable_moves = ["Thud", "Charge", "Smoke", "Firespit"]
	var moves = master_move_list.instantiate()
	load_move(moves.get_move("Thud"))
	load_move(moves.get_move("Charge"))
	health = max_hp
	$HpBar.max_value = max_hp
	print(moves_list)

func _process(delta):
	$HpBar.value = health

extends Mon

func _ready():
	learnable_moves = ["Thud", "Firespit"]
	load_move(master_move_list.get_move("Thud"))
	load_move(master_move_list.get_move("Firespit"))
	health = max_hp

func _process(_delta):
	hp_bar.text = str(health) + " / " + str(max_hp)

extends Mon

@onready var anim = $egg

func _ready():
	learnable_moves = ["Nibble", "Roll", "Focus", "Charge", "PancakeSlam"]
	load_move(master_move_list.get_move("Nibble"))
	load_move(master_move_list.get_move("Roll"))
	#load_move(moves.get_move("Teeth"))
	#load_move(moves.get_move("Blender"))
	#load_move(moves.get_move("Lick"))
	health = max_hp
	setup_stat_screen()

func play_anim(animation):
	pass

func play_idle_anim():
	pass

func play_atk_anim():
	$atk_sfx.play()

func play_brace_anim():
	pass

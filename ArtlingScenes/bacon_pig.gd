extends Mon

@onready var anim = $"Pig artling"
@onready var leader_button = stat_screen.leader_button

func _ready():
	learnable_moves = ["Thud", "Charge", "BaconSlap", "Lick"]
	load_move(master_move_list.get_move("Thud"))
	load_move(master_move_list.get_move("Charge"))
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

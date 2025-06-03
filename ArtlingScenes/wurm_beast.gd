extends Mon

@onready var anim = $AnimModel

func _ready():
	learnable_moves = ["Teeth", "Blender", "TeethShot", "Screech", "Grapple"]
	load_move(master_move_list.get_move("Teeth"))
	load_move(master_move_list.get_move("Blender"))
	load_move(master_move_list.get_move("TeethShot"))
	#load_move(moves.get_move("Teeth"))
	#load_move(moves.get_move("Blender"))
	#load_move(moves.get_move("Lick"))
	health = max_hp
	play_idle_anim()
	setup_stat_screen()

func play_anim(animation):
	anim.play_anim(animation)

func play_idle_anim():
	anim.play_idle()

func play_atk_anim():
	#anim.play_anim("bite")
	anim.play_attack()
	$atk_sfx.play()

func play_brace_anim():
	#anim.play_anim("hide")
	anim.play_idle()

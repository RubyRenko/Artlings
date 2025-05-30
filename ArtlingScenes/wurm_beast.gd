extends Mon

@onready var anim = $AnimModel

func _ready():
	learnable_moves = ["Teeth", "Blender", "TeethShot", "Lick"]
	load_move(master_move_list.get_move("Blender"))
	load_move(master_move_list.get_move("TeethShot"))
	#load_move(moves.get_move("Teeth"))
	#load_move(moves.get_move("Blender"))
	#load_move(moves.get_move("Lick"))
	health = max_hp
	setup_stat_screen()

func play_anim(animation):
	#anim.play_anim(animation)
	pass

func play_idle_anim():
	#anim.play_anim("idle")
	pass

func play_atk_anim():
	#anim.play_anim("bite")
	$atk_sfx.play()

func play_brace_anim():
	#anim.play_anim("hide")
	pass

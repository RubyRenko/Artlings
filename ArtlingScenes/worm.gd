extends Mon

@onready var anim = $AnimModel
@onready var leader_button = stat_screen.leader_button

func _ready():
	learnable_moves = ["Thud", "Charge", "Teeth", "Focus", "Blender", "Lick", "TeethShot"]
	load_move(master_move_list.get_move("Thud"))
	load_move(master_move_list.get_move("Charge"))
	#load_move(moves.get_move("Teeth"))
	#load_move(moves.get_move("Blender"))
	#load_move(moves.get_move("Lick"))
	health = max_hp
	anim.play_anim("idle")
	setup_stat_screen()

func _process(_delta):
	hp_bar.text = str(health) + " / " + str(max_hp)

func play_anim(animation):
	anim.play_anim(animation)

func play_idle_anim():
	anim.play_anim("idle")

func play_atk_anim():
	anim.play_anim("bite")
	$atk_sfx.play()

func play_brace_anim():
	anim.play_anim("hide")

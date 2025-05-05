extends Mon

@onready var anim = $AnimSprite
@onready var leader_button = stat_screen.leader_button

func _ready():
	learnable_moves = ["Brush", "Smoke", "Dollop", "InkSlash", "InkPool"]
	load_move(master_move_list.get_move("Brush"))
	load_move(master_move_list.get_move("Smoke"))
	"""load_move(moves.get_move("Dollop"))
	load_move(moves.get_move("InkSlash"))
	load_move(moves.get_move("InkPool"))"""
	health = max_hp
	setup_stat_screen()

func _process(_delta):
	hp_bar.text = str(health) + " / " + str(max_hp)

func play_anim(animation):
	anim.play(animation)

func play_idle_anim():
	anim.play("idle")

func play_atk_anim():
	anim.play("attack")

func play_brace_anim():
	anim.play("brace")

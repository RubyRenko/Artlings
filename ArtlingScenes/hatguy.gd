extends Mon

@onready var anim = $AnimSprite

func _ready():
	learnable_moves = ["Thud", "HatTip", "KarateKick"]
	load_move(master_move_list.get_move("Thud"))
	load_move(master_move_list.get_move("HatTip"))
	health = max_hp
	setup_stat_screen()

func play_anim(animation):
	anim.play(animation)

func play_idle_anim():
	anim.play("idle")

func play_atk_anim():
	anim.play("attack")
	$atk_sfx.play()

func play_brace_anim():
	anim.play("brace")

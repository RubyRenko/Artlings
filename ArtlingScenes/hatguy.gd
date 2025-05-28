extends Mon

@onready var anim = $AnimSprite
@onready var leader_button = stat_screen.leader_button

func _ready():
	learnable_moves = ["Brush", "Smoke", "Dollop", "InkSlash", "Stipple", "InkBlot"]
	load_move(master_move_list.get_move("Brush"))
	load_move(master_move_list.get_move("Smoke"))
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

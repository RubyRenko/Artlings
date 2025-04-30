extends Node3D

@onready var anim_player = $AnimationPlayer

func play_anim(animation):
	if animation in anim_player.get_animation_list():
		print("playing animation: " + animation)
		anim_player.play(animation)

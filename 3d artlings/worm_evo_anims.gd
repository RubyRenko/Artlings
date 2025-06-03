extends Node3D

@onready var anim_player = $AnimationPlayer

func play_anim(animation):
	anim_player.play(animation)

func play_idle():
	anim_player.play("idle-Armature_001")

func play_brace():
	anim_player.play("idle-Armature_001")

func play_attack():
	var to_play = ["jump bite", "swipe"].pick_random()
	anim_player.play(to_play)

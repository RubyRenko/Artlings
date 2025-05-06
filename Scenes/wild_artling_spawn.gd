extends Marker3D

var wild_artling_scene = load("res://ArtlingScenes/wild_artling.tscn")
var wa = wild_artling_scene.instantiate()
@onready var timer = $Timer
var mons_spawned = 0

func _ready():
	add_child(wa)
	wa.global_position = position

func _on_child_exiting_tree(node):
	if node == wa:
		timer.start()

func _on_timer_timeout():
	wa = wild_artling_scene.instantiate()
	add_child(wa)
	wa.global_position = position
	wa.set_level(ceili(mons_spawned/2))
	mons_spawned += 1
	print(wa.artling.level)
	timer.stop()

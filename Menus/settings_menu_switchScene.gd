extends Node

var current_scene_path

func _ready() -> void:
	var root = get_tree().root
	current_scene_path = root.get_child(root.get_child_count() - 1)
	print_debug(current_scene_path)

func switch_scene(res_path):
	call_deferred("_deferred_switch_scene", res_path)

func _deferred_switch_scene(res_path):
	current_scene_path.free()
	var s = load(res_path)
	current_scene_path = s.instantiate
	get_tree().root.add_child(current_scene_path)
	get_tree().current_scene_path = current_scene_path

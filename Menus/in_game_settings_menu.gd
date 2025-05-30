extends Panel

#code for in-game settings menu ui

@onready var parent_node = get_node(".")

func _on_return_button_pressed() -> void:
	parent_node.set_visible(false)

func _on_title_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Menus/title_screen.tscn")

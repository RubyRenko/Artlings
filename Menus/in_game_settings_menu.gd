extends Panel

@onready var parent_node = get_node(".")

func _input(event):
	if event.is_action_pressed("options"):
		parent_node.visible = !parent_node.visible


# func toggle_options_button(button_pressed):
#	button_pressed.is_action_pressed("options")
#	if button_pressed:
#		print("Button is on")
#		
#	else:
#		print("button is off")
#		parent_node.visible(false)

func _on_return_button_pressed() -> void:
	parent_node.set_visible(false)

func _on_title_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Menus/title_screen.tscn")

extends Control

#start button
func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/level_handler.tscn")

#options button
func _on_options_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Menus/settings_menu.tscn")

#quit button
func _on_quit_button_pressed() -> void:
	get_tree().quit()

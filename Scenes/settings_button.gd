extends Button

#in-game settings button code

@onready var child_node = get_node("../inGame_settings_menu")

func _on_pressed() -> void:
	child_node.visible = !child_node.visible

extends Control

@onready var tutorial_nodes = get_children()
var node_index = 0

func _process(_delta):
	if Input.is_action_just_pressed("next") && get_parent().visible:
		print(visible)
		tutorial_nodes[node_index].visible = false
		node_index += 1
		if node_index < len(tutorial_nodes):
			tutorial_nodes[node_index].visible = true
		elif node_index >= len(tutorial_nodes):
			node_index = 0
			tutorial_nodes[node_index].visible = true
	
	if Input.is_action_just_pressed("back") && get_parent().visible:
		tutorial_nodes[node_index].visible = false
		node_index -= 1
		if node_index >= 0:
			tutorial_nodes[node_index].visible = true
		elif node_index < 0:
			node_index = len(tutorial_nodes)-1
			tutorial_nodes[node_index].visible = true

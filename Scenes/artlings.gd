extends Node

@onready var master_artlings_list = preload("res://artlings_list.tscn")
@onready var artlings = master_artlings_list.instantiate()

func add_teammate(mon_name):
	var new_teammate = artlings.get_artling(mon_name)
	var n = new_teammate.instantiate()
	n.position = get_parent().position
	n.visible = false
	add_child(n)
	get_parent().load_team()

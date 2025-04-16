extends Node
@onready var artlings_list = ArtlingsMasterlist.new()

func add_teammate(mon_name):
	var new_teammate = artlings_list.get_artling(mon_name)
	var n = new_teammate.instantiate()
	n.position = get_parent().position
	n.visible = false
	add_child(n)
	get_parent().load_team()

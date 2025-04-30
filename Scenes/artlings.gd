extends Node
@onready var artlings_list = ArtlingsMasterlist.new()

func add_teammate(mon_name):
	var new_teammate = artlings_list.get_artling(mon_name)
	var n = new_teammate.instantiate()
	n.position = get_parent().position
	n.position.y = n.position.y + 50
	n.visible = false
	add_child(n)
	get_parent().load_team()

func show_team_status(index):
	var to_show = get_child(index)
	to_show.stat_screen.visible = true

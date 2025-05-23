extends Node
@onready var artlings_list = ArtlingsMasterlist.new()

func add_teammate(mon_name, nickname = mon_name):
	var new_teammate = artlings_list.get_artling(mon_name)
	var n = new_teammate.instantiate()
	n.position = get_parent().position
	n.position.y = n.position.y + 50
	n.visible = false
	n.nickname = nickname
	add_child(n)
	n.setup_stat_screen()

func show_team_status(index):
	var to_show = get_child(index)
	to_show.stat_screen.visible = true

func remove_artling(ind):
	get_child(ind).queue_free()

func remove_all():
	for artling in get_children():
		artling.queue_free()

extends Panel

@onready var artlings = $Artlings
@onready var test = $Artlings/Artling1
func update_battle_party(team):
	for i in artlings.get_child_count():
		var node = artlings.get_child(i)
		if i < len(team):
			node.visible = true
			node.texture_normal = team[i].img
			var node_name = node.get_child(0)
			var hp_bar = node.get_child(1)
			var exp_bar = node.get_child(2)
			node_name.set_text(team[i].nickname)
			hp_bar.max_value = team[i].max_hp
			hp_bar.value = team[i].health
			exp_bar.value = team[i].exp
			if team[i].fainted:
				node.disabled = true
			if i == 0:
				node.disabled = true
			else:
				node.disabled = false
		elif i >= len(team):
			node.visible = false

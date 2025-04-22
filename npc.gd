extends Area3D

@onready var battle_test = load("res://Scenes/battlefield.tscn")
@onready var mon = $ExampleNpcMon
@onready var battle_pos = $BattleMarker.position
var battling = false
var player = null

func _on_body_entered(body):
	if body.name == "Player" && !battling:
		$Label3D.show()
		player = body
		var battle = battle_test.instantiate()
		battle.position = battle_pos
		add_child(battle)
		battle.load_mons(body.team[0], mon)
		battle.load_moves()
		battling = true
		player.can_move = false
		player.party_tab.visible = false
		player.change_camera(battle.camera_node.global_position)

func _on_child_exiting_tree(node):
	if node.is_in_group("battle"):
		battling = false
		player.can_move = true
		player.party_tab.visible = true
		player.revert_camera()

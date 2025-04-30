extends Area3D

@onready var battle_test = load("res://Scenes/battlefield.tscn")
@onready var mon = $ExampleNpcMon
@onready var battle_pos = $BattleMarker.position
var battling = false
var player = null

func _on_body_entered(body):
	# if the player gets within the area
	if body.name == "Player" && !battling:
		# sets the player to the body so we can reference it later
		player = body
		# creates a new battlefield where the battle marker is
		# loads the player and enemy mons
		var battle = battle_test.instantiate()
		battle.position = battle_pos
		add_child(battle)
		battle.load_mons(player, [mon])
		battle.load_moves()
		battling = true
		# disables player movement and party tab, also sets the camera
		player.battling = true
		player.can_move = false
		player.party_tab.visible = false
		player.change_camera(battle.camera_node.global_position)

func _on_child_exiting_tree(node):
	# when the battle is over
	if node.is_in_group("battle"):
		# sets battle to false and returns movement/camera to the player
		battling = false
		player.can_move = true
		player.revert_camera()

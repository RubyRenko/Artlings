extends Area3D

@onready var battle_test = load("res://Scenes/battlefield.tscn")
@onready var mon = $worm2
@onready var battle_pos = $BattleMarker.position
@onready var start_pos = global_position
@onready var sprite = $worm
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
		sprite.visible = false
		# disables player movement and party tab, also sets the camera
		player.battling = true
		player.can_move = false
		player.hide_screens()
		player.party_button.visible = false
		player.party_button.disabled = true
		player.create_button.visible = false
		player.create_button.disabled = true
		player.change_camera(battle.camera_node.global_position)

func _on_child_exiting_tree(node):
	# when the battle is over
	if node.is_in_group("battle"):
		# sets battle to false and returns movement/camera to the player
		battling = false
		sprite.visible = true
		player.can_move = true
		player.battling = false
		player.party_button.visible = true
		player.party_button.disabled = false
		player.create_button.visible = true
		player.create_button.disabled = false
		player.inspo += 1
		player.revert_camera()

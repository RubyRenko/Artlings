extends CharacterBody3D

@onready var gravity = -ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var artling_list = ArtlingsMasterlist.new()
@onready var artling = artling_list.get_random_artling().instantiate()
@onready var battlefield = load("res://Scenes/battlefield.tscn")
@onready var battle_pos = $BattleMarker.position
@onready var start_pos = global_position
@export var artling_level : int
var battling = false
var player = null

func _ready():
	add_child(artling)

func _physics_process(delta):
	if !battling:
		velocity.y += delta * gravity
		move_and_slide()
		artling.global_position = global_position

func set_level(level):
	for i in level-1:
		artling.add_experience(100)
	#print(artling.level)

func _on_battle_area_body_entered(body):
	# if the player gets within the area
	if body.name == "Player" && !battling:
		# sets the player to the body so we can reference it later
		player = body
		# creates a new battlefield where the battle marker is
		# loads the player and enemy mons
		var battle = battlefield.instantiate()
		battle.position = battle_pos
		add_child(battle)
		battle.load_mons(player, [artling])
		battle.load_moves()
		battling = true
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
		player.can_move = true
		player.battling = false
		player.party_button.visible = true
		player.party_button.disabled = false
		player.create_button.visible = true
		player.create_button.disabled = false
		player.inspo += 1
		player.revert_camera()
		queue_free()

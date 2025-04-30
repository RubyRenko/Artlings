extends CharacterBody3D

@onready var gravity = -ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var team_node = $Artlings
@onready var party_tab = $PartyScreen
@onready var artlings_list = ArtlingsMasterlist.new()
@onready var camera = $Camera3D
@onready var camera_pos = camera.position

var speed = 100.0
var max_jump = 5.0
var jump = false
var team = []
var can_move = true
var battling = false

func _ready():
	# adds the 3 starters to the team
	team_node.add_teammate("worm")
	team_node.add_teammate("ink starter")
	team_node.add_teammate("water starter")
	party_tab.visible = false
	#print("current team")
	#print(team)

func _physics_process(delta):
	# creates direction vector
	var direction : Vector3
	# sets the horizontal movement to wasd/arrows input
	direction.x = Input.get_axis("left", "right")
	direction.z = Input.get_axis("up", "down")
	
	# sets the speed depending on if the run key is pressed or not
	if Input.is_action_pressed("run") && can_move:
		speed = 200.0
	else:
		speed = 100.0
	
	# if the jump button is pressed once and is on the floor
	if Input.is_action_just_pressed("jump") && is_on_floor() && can_move:
		# puts into jummping state and gives a first boost of height
		jump = true
		velocity.y += 3.0
	
	# if jump button is held down and currently in the middle of jumping
	if Input.is_action_pressed("jump") && velocity.y < max_jump && jump && can_move:
		# adds small bit of velocity until it hits max jump
		velocity.y += 0.3
	elif velocity.y > max_jump:
		# when velocity hits max jump, sets jump to false so player starts to fall
		jump = false
	
	if Input.is_action_just_pressed("party_tab") && !battling:
		toggle_party_screen()
	
	# when player can move
	if can_move:
		# adds gravity to y
		# makes player move horizontally based on direction
		velocity.y += delta * gravity
		velocity.x = direction.x * delta * speed
		velocity.z = direction.z * delta * speed
		
		move_and_slide()

func load_team():
	# updates team based off the children in teamnode and updates party_tab
	team = team_node.get_children()
	party_tab.toggle_party_buttons(team)

func _on_artling_1_pressed():
	show_artling(0)

func _on_artling_2_pressed():
	show_artling(1)

func _on_artling_3_pressed():
	show_artling(2)

func _on_artling_4_pressed():
	show_artling(3)

func _on_artling_5_pressed():
	show_artling(4)

func _on_artling_6_pressed():
	show_artling(5)

func show_artling(ind):
	# if the stat screen is currently visible
	if team[ind].stat_screen.visible:
		# hides stat screen, updates values, and lets player move again
		team[ind].stat_screen.visible = false
		can_move = true
		team[ind].update_from_stat_screen()
	# if the stat screen isn't visible
	else:
		# hides other stat screens and makes sure stat screen is up to date
		# shows stat screen and disabls movement
		hide_screens()
		team[ind].setup_stat_screen()
		team[ind].stat_screen.visible = true
		can_move = false

func hide_screens():
	# for every teammate, hides the stat screen if it's visible
	for teammate in team:
		if teammate.stat_screen.visible == true:
			teammate.stat_screen.visible = false
	if party_tab.visible:
		party_tab.visible = false

func change_camera(global_pos):
	# sets the camera to a specific position
	camera.global_position = global_pos

func revert_camera():
	# changes the camera back to starting position (paired to the player)
	camera.position = camera_pos

func cycle_team():
	team.append(team[0])
	team[0] = team.pop_at(1)
	party_tab.toggle_party_buttons(team)

func toggle_party_screen():
	party_tab.toggle_party_buttons(team)
	if party_tab.visible == true:
		hide_screens()
		if !battling:
			can_move = true
	else:
		hide_screens()
		party_tab.visible = true
		can_move = false

extends CharacterBody3D

@onready var gravity = -ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var team_node = $Artlings
@onready var party_tab = $PlayerPartyTab
@onready var artlings_list = ArtlingsMasterlist.new()
var speed = 100.0
var max_jump = 8.0
var jump = false
var team = []
var can_move = true

func _ready():
	team_node.add_teammate("worm")
	team_node.add_teammate("ink starter")
	team_node.add_teammate("water starter")
	print("current team")
	print(team)

func _physics_process(delta):
	var direction : Vector3
	direction.x = Input.get_axis("left", "right")
	direction.z = Input.get_axis("up", "down")
	
	if Input.is_action_pressed("run") && can_move:
		speed = 200.0
	else:
		speed = 100.0
	
	if Input.is_action_just_pressed("jump") && is_on_floor() && can_move:
		jump = true
	
	if Input.is_action_pressed("jump") && velocity.y < max_jump && jump && can_move:
		velocity.y += 0.5
	elif velocity.y > max_jump:
		jump = false
	
	if Input.is_action_just_pressed("cycle_team"):
		team.append(team[0])
		team[0] = team.pop_at(1)
		print("current team")
		print(team)
	
	if can_move:
		velocity.y += delta * gravity
		velocity.x = direction.x * delta * speed
		velocity.z = direction.z * delta * speed
		
		move_and_slide()

func load_team():
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
	if team[ind].stat_screen.visible:
		team[ind].stat_screen.visible = false
		can_move = true
	else:
		team[ind].stat_screen.visible = true
		can_move = false

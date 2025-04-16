extends CharacterBody3D

@onready var gravity = -ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var team_node = $Artlings
@onready var artlings_list = ArtlingsMasterlist.new()
var speed = 100.0
var max_jump = 8.0
var jump = false
var team = []

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
	
	if Input.is_action_pressed("run"):
		speed = 200.0
	else:
		speed = 100.0
	
	if Input.is_action_just_pressed("jump") && is_on_floor():
		jump = true
	
	if Input.is_action_pressed("jump") && velocity.y < max_jump && jump:
		velocity.y += 0.5
	elif velocity.y > max_jump:
		jump = false
	
	if Input.is_action_just_pressed("cycle_team"):
		team.append(team[0])
		team[0] = team[1]
		team.pop_at(1)
		print("current team")
		print(team)
	
	velocity.y += delta * gravity
	velocity.x = direction.x * delta * speed
	velocity.z = direction.z * delta * speed
	
	move_and_slide()

func _on_npc_body_exited(body):
	pass # Replace with function body.

func load_team():
	team = team_node.get_children()

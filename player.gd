extends CharacterBody3D

@onready var gravity = -ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var team_node = $Artlings
var speed = 100.0
var max_jump = 8.0
var jump = false
var team = []

func _ready():
	team_node.add_teammate("worm")

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
	
	velocity.y += delta * gravity
	velocity.x = direction.x * delta * speed
	velocity.z = direction.z * delta * speed
	
	move_and_slide()

func _on_npc_body_exited(body):
	pass # Replace with function body.

func load_team():
	for child in team_node.get_children():
		team.append(child)
	print(team)

extends Node3D

@onready var team_node = $Artlings
static var team = []

func _ready():
	team_node.add_teammate("Inkit")
	load_team()
	team_node.add_teammate("Dewphin")
	load_team()
	team_node.add_teammate("Wurm")
	load_team()

func load_team():
	# updates team based off the children in teamnode and updates party_tab
	team = team_node.get_children()

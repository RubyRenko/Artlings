extends Area3D

@onready var battle_test = load("res://Scenes/battlefield.tscn")
@onready var mon = $ExampleNpcMon
@onready var battle_pos = $BattleMarker.position
var battling = false

func _ready():
	$Label3D.hide()

func _on_body_entered(body):
	if body.name == "Player" && !battling:
		$Label3D.show()
		var battle = battle_test.instantiate()
		battle.position = battle_pos
		add_child(battle)
		battle.load_mons(body.team[0], mon)
		battle.load_moves()
		battling = true

func _on_body_exited(body):
	if body.name == "Player":
		$Label3D.hide()

func _on_child_exiting_tree(node):
	if node.is_in_group("battle"):
		battling = false

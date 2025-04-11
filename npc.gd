extends Area3D

@onready var battle_test = load("res://Scenes/battlefield.tscn")
@onready var team = [$ExampleNpcMon]
var battling = false

func _ready():
	$Label3D.hide()
	var test_move = Move.new()
	test_move.set_stats(15, 100, "Fire", "Fireball")
	$Label3D.set_text(str(test_move))

func _on_body_entered(body):
	if body.name == "Player" && !battling:
		$Label3D.show()
		var battle = battle_test.instantiate()
		battle.position = position
		battle.position.z += 1
		add_child(battle)
		battle.load_mons(body.team[0], team[0])
		battle.load_moves(body.team[0].moves_list)
		battling = true

func _on_body_exited(body):
	if body.name == "Player":
		$Label3D.hide()

func _on_child_exiting_tree(node):
	if node.is_in_group("battle"):
		battling = false
		team[0].health = team[0].max_hp

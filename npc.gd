extends Area3D

@onready var battle_test = load("res://Scenes/test.tscn")
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
		add_child(battle)
		battling = true

func _on_body_exited(body):
	if body.name == "Player":
		$Label3D.hide()

func _on_child_exiting_tree(node):
	if node.is_in_group("battle"):
		battling = false

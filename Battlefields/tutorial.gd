extends Node3D

@onready var battle_node = $BattleNew
var tutorial_on = true

func start_battle(player_mons, enemy_mons):
	battle_node.load_mons(player_mons, enemy_mons)

func _on_child_exiting_tree(node):
	if node == battle_node:
		queue_free()

func _process(_delta):
	if battle_node.party_screen.visible && tutorial_on:
		$Tutorial/BattleInfoStep.visible = false
		$Tutorial/PartyInfo.visible = true
	elif !battle_node.party_screen.visible && tutorial_on:
		$Tutorial/PartyInfo.visible = false
		$Tutorial/BattleInfoStep.visible = true
	
	if battle_node.option_screen.visible && tutorial_on:
		$Tutorial.visible = false
	elif tutorial_on:
		$Tutorial.visible = true
	
	if Input.is_action_just_pressed("tutorial"):
		tutorial_on = !tutorial_on
		if !tutorial_on:
			$Tutorial.visible = false
	if Input.is_action_just_pressed("skip tutorial"):
		$BattleNew.queue_free()

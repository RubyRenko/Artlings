extends Node3D

@onready var battle_node = $BattleNew

func start_battle(player_mons, enemy_mons):
	battle_node.load_mons(player_mons, enemy_mons)

func _on_child_exiting_tree(node):
	if node == battle_node:
		queue_free()

func _process(_delta):
	if battle_node.party_screen.visible == true:
		$Tutorial/BattleInfo.visible = false
		$Tutorial/PartyInfo.visible = true
	elif battle_node.party_screen.visible == false:
		$Tutorial/BattleInfo.visible = true
		$Tutorial/PartyInfo.visible = false
	
	if Input.is_action_just_pressed("tutorial"):
		$Tutorial.visible = !$Tutorial.visible
	elif Input.is_action_just_pressed("skip tutorial"):
		$BattleNew.queue_free()

extends Node3D

@onready var battle_node = $BattleNew
@onready var player_marker = $BattleNew/PlayerMarker
@onready var enemy_marker = $BattleNew/EnemyMarker
var tutorial_on = true

func start_battle(player, enemy):
	if player_marker != null:
		battle_node.player_spawn = player_marker
	if enemy_marker != null:
		battle_node.enemy_spawn = enemy_marker
	battle_node.load_mons(player, enemy)

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
		$BattleNew.battle_skipped = true
		$BattleNew.continue_battle(-2)
		$BattleNew.can_click = true

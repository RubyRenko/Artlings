extends Node3D

@onready var player_spawn = $PlayerMonSpawn
@onready var enemy_spawn = $EnemyMonSpawn
@onready var move_options = $CanvasLayer/MoveOptions
@onready var battle_desc = $CanvasLayer/Panel/BattleDesc

var player_mon : Node3D
var enemy_mon : Node3D

var battle_prog = -1
var commands = []
var battle_won = false
var test : Dictionary

func load_mons(player_inp, enemy_inp):
	if player_inp.is_in_group("mon"):
		player_mon = player_inp
		player_mon.global_position = player_spawn.global_position
		player_mon.visible = true
		print(player_mon.level)
	if enemy_inp.is_in_group("mon"):
		enemy_mon = enemy_inp
		enemy_mon.global_position = enemy_spawn.global_position
		enemy_mon.visible = true
		print(enemy_mon.level)

func load_moves():
	#print(player_mon.moves_list)
	move_options.load_moves(player_mon.current_moves)

func _process(delta):
	if battle_prog >= len(commands):
		battle_prog = -1
		move_options.load_moves(player_mon.moves_list)
		commands = []
	elif battle_prog > -1 && battle_prog < len(commands):
		move_options.disable_buttons()
	if Input.is_action_just_pressed("progress_battle") && battle_prog == -2:
		move_options.disable_buttons()
		if battle_won:
			battle_desc.set_text("Battle won!")
			player_mon.add_experience(100)
			#print("Player level: " + str(player_mon.level))
		else:
			battle_desc.set_text("Battle lost...")
			#player_mon.add_experience(100)
			#print("Player level: " + str(player_mon.level))
		player_mon.visible = false
		enemy_mon.visible = false
		player_mon.health = player_mon.max_hp
		enemy_mon.health = enemy_mon.max_hp
		battle_prog = -3
	elif Input.is_action_just_pressed("progress_battle") && battle_prog == -3:
		queue_free()
	elif Input.is_action_just_pressed("progress_battle") && battle_prog > -1:
		var current_command = commands[battle_prog]
		handle_turn(current_command)
	
	if player_mon.health <= 0 && battle_prog != -3:
		commands = []
		battle_prog = -2
	elif enemy_mon.health <= 0 && battle_prog != -3:
		battle_won = true
		commands = []
		battle_prog = -2

func _on_move_1_pressed():
	choose_move(0)
	handle_status()
	handle_turn(commands[0])

func _on_move_2_pressed():
	choose_move(1)
	handle_status()
	handle_turn(commands[0])

func _on_move_3_pressed():
	choose_move(2)
	handle_status()
	handle_turn(commands[0])

func _on_move_4_pressed():
	choose_move(3)
	handle_status()
	handle_turn(commands[0])

func choose_move(move_ind):
	if player_mon.speed >= enemy_mon.speed:
		commands.append(["desc", "Using " + move_options.choosable_moves[move_ind] + "!"])
		commands.append(["player", move_options.choosable_moves[move_ind] ])
		var enemy_move = enemy_mon.moves_list.keys().pick_random()
		commands.append(["desc", "Enemy used " + enemy_move + "!"])
		commands.append(["enemy", enemy_move])
		#handle_status()
		battle_prog = 0
	else:
		var enemy_move = enemy_mon.moves_list.keys().pick_random()
		commands.append(["desc", "Enemy used " + enemy_move + "!"])
		commands.append(["enemy", enemy_move])
		commands.append(["desc", "Using " + move_options.choosable_moves[move_ind] + "!"])
		commands.append(["player", move_options.choosable_moves[move_ind] ])
		#handle_status()
		battle_prog = 0

func handle_turn(current_command):
	if current_command[0] == "player":
		var battle_lines = player_mon.attack(enemy_mon, current_command[1])
		battle_desc.set_text(battle_lines)
		battle_prog += 1
	elif current_command[0] == "enemy":
		var battle_lines = enemy_mon.attack(player_mon, current_command[1])
		battle_desc.set_text(battle_lines)
		battle_prog += 1
	elif current_command[0] == "enemystatus":
		var battle_lines = enemy_mon.take_status(current_command[1])
		battle_desc.set_text(battle_lines)
		battle_prog += 1
	elif current_command[0] == "playerstatus":
		var battle_lines = player_mon.take_status(current_command[1])
		battle_desc.set_text(battle_lines)
		battle_prog += 1
	elif current_command[0] == "desc":
		battle_desc.set_text(current_command[1])
		battle_prog += 1
	#print(battle_prog)

func handle_status():
	if player_mon.status_counter <= 0 && player_mon.status != "None":
		commands.append(["desc", player_mon.status + " wore off."])
		player_mon.status = "None"
		print(player_mon.status + str(player_mon.status_counter))
	elif player_mon.status != "None":
		commands.append(["playerstatus", player_mon.status])
		player_mon.status_counter -= 1
		print(player_mon.status + str(player_mon.status_counter))
	
	if enemy_mon.status_counter <= 0 && enemy_mon.status != "None":
		commands.append(["desc", "Enemy's " + enemy_mon.status + " wore off."])
		enemy_mon.status = "None"
		print(enemy_mon.status + str(enemy_mon.status_counter))
	elif enemy_mon.status != "None":
		commands.append(["enemystatus", enemy_mon.status])
		enemy_mon.status_counter -= 1
		print(enemy_mon.status + str(enemy_mon.status_counter))

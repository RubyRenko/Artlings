extends Node3D

@onready var player_spawn = $PlayerMonSpawn
@onready var enemy_spawn = $EnemyMonSpawn
@onready var move_options = $CanvasLayer/MoveOptions
@onready var battle_desc = $CanvasLayer/BattleText/BattleDesc
@onready var camera_node = $CameraMarker
@onready var master_move_list = preload("res://move_list.tscn").instantiate()

var player_mon : Node3D
var enemy_mon : Node3D

var battle_prog = -1
var commands = []
var battle_won = false
var test : Dictionary

func load_mons(player_inp, enemy_inp):
	# makes sure player and enemy mon are actually artlings
	if player_inp.is_in_group("mon"):
		# sets the player mon to the input and puts it where it's supposed to be
		player_mon = player_inp
		player_mon.global_position = player_spawn.global_position
		player_mon.visible = true
		#print(player_mon.level)
	if enemy_inp.is_in_group("mon"):
		# sets the enemy mon to the input and puts it where it's supposed to be
		enemy_mon = enemy_inp
		enemy_mon.global_position = enemy_spawn.global_position
		enemy_mon.visible = true
		#print(enemy_mon.level)

func load_moves():
	#print(player_mon.current_moves)
	move_options.toggle_move_buttons(player_mon.current_moves)

func _process(_delta):
	# if we're at the end of the commands
	# resets battle prog to 1 and lets players pick moves
	if battle_prog >= len(commands):
		battle_prog = -1
		move_options.enable_buttons(len(player_mon.current_moves))
		commands = []
	# disables buttons whenevr not picking moves
	elif battle_prog > -1 && battle_prog < len(commands):
		move_options.disable_buttons()
	
	# when trying to progress battle and one mon is lost
	if Input.is_action_just_pressed("progress_battle") && battle_prog == -2:
		# disables buttons
		move_options.disable_buttons()
		# shows text based on if battle was won or lost
		# adds exprience to player
		if battle_won:
			battle_desc.set_text("Battle won!")
			player_mon.add_experience(100)
			#print("Player level: " + str(player_mon.level))
		else:
			battle_desc.set_text("Battle lost...")
			#player_mon.add_experience(100)
			#print("Player level: " + str(player_mon.level))
		# resets the enemy and player mon health and makes them invisible
		player_mon.visible = false
		enemy_mon.visible = false
		player_mon.health = player_mon.max_hp
		enemy_mon.health = enemy_mon.max_hp
		# sets battle prog to -3 so the battle queues free and ends
		battle_prog = -3
	# after clicking with battle prog being 3, clears the battle
	elif Input.is_action_just_pressed("progress_battle") && battle_prog == -3:
		queue_free()
	# goes down the list of commands and executes them when battle prog is positive
	elif Input.is_action_just_pressed("progress_battle") && battle_prog > -1:
		var current_command = commands[battle_prog]
		handle_turn(current_command)
	
	# if the player or enemy has no more health
	# clears commands and sets battle prog to -2 so it can display win or lose text
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
	# if the player is faster, appends player commands first
	if player_mon.speed >= enemy_mon.speed:
		# puts the move used by the player in the commands list
		commands.append(["desc", "Using " + player_mon.current_moves[move_ind] + "!"])
		commands.append(["player", player_mon.current_moves[move_ind] ])
		# picks a random move for the enemy and puts it in the commands list
		var enemy_move = enemy_mon.current_moves.pick_random()
		commands.append(["desc", "Enemy used " + enemy_move + "!"])
		commands.append(["enemy", enemy_move])
		# sets battle_prog to 0 so it starts the turn
		battle_prog = 0
	# otherwise appends enemy commands first
	else:
		# picks a random move for the enemy and puts it in the commands list
		var enemy_move = enemy_mon.current_moves.pick_random()
		commands.append(["desc", "Enemy used " + enemy_move + "!"])
		commands.append(["enemy", enemy_move])
		# puts the move used by the player in the commands list
		commands.append(["desc", "Using " + player_mon.current_moves[move_ind] + "!"])
		commands.append(["player", player_mon.current_moves[move_ind] ])
		# sets battle_prog to 0 so it starts the turn
		battle_prog = 0

func handle_turn(current_command):
	# if the command is from the player
	if current_command[0] == "player":
		# player mon attacks and sets the battle description to the result of attack
		var battle_lines = player_mon.attack(enemy_mon, current_command[1])
		battle_desc.set_text(battle_lines)
		battle_prog += 1
	# if the command is from the enemy
	elif current_command[0] == "enemy":
		# enemy mon attacks and sets the battle description to the result of attack
		var battle_lines = enemy_mon.attack(player_mon, current_command[1])
		battle_desc.set_text(battle_lines)
		battle_prog += 1
	# if the command is a status affecting the enemy
	elif current_command[0] == "enemystatus":
		# makes the enemy take the status effect and sets the battle desc to the result
		var battle_lines = enemy_mon.take_status()
		battle_desc.set_text(battle_lines)
		battle_prog += 1
	# if the command is a status affecting the player
	elif current_command[0] == "playerstatus":
		# makes the player take the status effect and sets the battle desc to the result
		var battle_lines = player_mon.take_status()
		battle_desc.set_text(battle_lines)
		battle_prog += 1
	# if the command is flavor text
	elif current_command[0] == "desc":
		# sets the desc to the flavor text and continues
		battle_desc.set_text(current_command[1])
		battle_prog += 1
	#print(battle_prog)

func handle_status():
	# if the status counter ticks down to 0, clears the status effect
	if player_mon.status_counter <= 0 && player_mon.status != "None":
		commands.append(["desc", player_mon.status + " wore off."])
		player_mon.status = "None"
		#print(player_mon.status + str(player_mon.status_counter))
	# if the player has a status, counts down the timer by 1
	elif player_mon.status != "None":
		commands.append(["playerstatus", player_mon.status])
		player_mon.status_counter -= 1
		#print(player_mon.status + str(player_mon.status_counter))
	# if the status counter ticks down to 0, clears the status effect
	if enemy_mon.status_counter <= 0 && enemy_mon.status != "None":
		commands.append(["desc", "Enemy's " + enemy_mon.status + " wore off."])
		enemy_mon.status = "None"
		#print(enemy_mon.status + str(enemy_mon.status_counter))
	# if the enemy has a status, counts down the timer by 1
	elif enemy_mon.status != "None":
		commands.append(["enemystatus", enemy_mon.status])
		enemy_mon.status_counter -= 1
		#print(enemy_mon.status + str(enemy_mon.status_counter))

# displays the description of the move when the buttons are hovered over
func _on_move_1_mouse_entered():
	if battle_prog == -1:
		battle_desc.set_text( str(player_mon.moves_list[player_mon.current_moves[0]]) )

func _on_move_2_mouse_entered():
	if battle_prog == -1 && len(player_mon.current_moves) >= 2:
		battle_desc.set_text( str(player_mon.moves_list[player_mon.current_moves[1]]) )

func _on_move_3_mouse_entered():
	if battle_prog == -1 && len(player_mon.current_moves) >= 3:
		battle_desc.set_text( str(player_mon.moves_list[player_mon.current_moves[2]]) )

func _on_move_4_mouse_entered():
	if battle_prog == -1 && len(player_mon.current_moves) == 4:
		battle_desc.set_text( str(player_mon.moves_list[player_mon.current_moves[3]]) )

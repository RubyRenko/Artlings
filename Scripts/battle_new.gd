extends Node3D

@onready var player_spawn = $PlayerMonSpawn
@onready var player_hp_bar = $CanvasLayer/PlayerHpBar
@onready var player_name_label = $CanvasLayer/PlayerHpBar/Label
@onready var enemy_spawn = $EnemyMonSpawn
@onready var enemy_hp_bar = $CanvasLayer/EnemyHpBar
@onready var enemy_name_label = $CanvasLayer/EnemyHpBar/Label

@onready var move_opt = $CanvasLayer/MoveOptions
@onready var battle_desc = $CanvasLayer/BattleText/BattleDesc
@onready var battle_desc_box = $CanvasLayer/BattleText
@onready var change_button = $CanvasLayer/ChangeArtling
@onready var master_move_list = preload("res://move_list.tscn").instantiate()
@onready var anim_tween = get_tree().create_tween()

var player
var player_team : Array
var mons_for_exp : Array
var enemy_team : Array
var player_mon : Node3D
var enemy_mon : Node3D

var battle_prog = -1
var commands = []
var battle_won = false
var test : Dictionary

func load_mons(player_inp, enemy_inp):
	# sets the player to the input and player team with the first mon going into battle
	player = player_inp
	player_team = player_inp.team
	player_mon = player_team[0]
	player_mon.global_position = player_spawn.global_position
	mons_for_exp.append(player_mon)
	
	player_mon.visible = true
	player_name_label.set_text(player_mon.nickname)
	player_hp_bar.max_value = player_mon.max_hp
	player_hp_bar.value = player_mon.health
	#print(player_mon.level)
	
	# sets the enemy mon to the input and puts it where it's supposed to be
	enemy_team = enemy_inp
	enemy_mon = enemy_team[0]
	enemy_mon.global_position = enemy_spawn.global_position
	enemy_mon.visible = true
	if enemy_mon.is_in_group("2d"):
		enemy_mon.anim.flip_h = true
	
	enemy_name_label.set_text(enemy_mon.nickname)
	enemy_hp_bar.max_value = enemy_mon.max_hp
	enemy_hp_bar.value = enemy_mon.health
	#print(enemy_mon.level)
	load_moves()

func load_moves():
	#print(player_mon.current_moves)
	move_opt.toggle_move_buttons(player_mon.current_moves)

func _process(_delta):
	# if we're at the end of the commands
	# resets battle prog to 1 and lets players pick moves
	if battle_prog >= len(commands):
		battle_prog = -1
		move_opt.enable_buttons(len(player_mon.current_moves))
		change_button.disabled = false
		commands = []
		player_mon.play_idle_anim()
		enemy_mon.play_idle_anim()
	# disables buttons whenevr not picking moves
	elif battle_prog > -1 && battle_prog < len(commands):
		move_opt.disable_buttons()
		change_button.disabled = true
	
	# when trying to progress battle and one mon is lost
	if Input.is_action_just_pressed("progress_battle") && battle_prog == -2:
		# disables buttons
		move_opt.disable_buttons()
		# shows text based on if battle was won or lost
		# adds exprience to player
		if battle_won:
			battle_desc.set_text("Battle won!")
			for mon in mons_for_exp:
				var exp = 100/len(mons_for_exp)
				mon.add_experience(exp)
			#print("Player level: " + str(player_mon.level))
		else:
			battle_desc.set_text("Battle lost...")
			#player_mon.add_experience(100)
			#print("Player level: " + str(player_mon.level))
		# resets the enemy and player mon health and makes them invisible
		for mon in enemy_team:
			mon.visible = false
			mon.health = mon.max_hp
		for mon in player_team:
			mon.visible = false
			mon.health = mon.max_hp
		player.inspo += 2
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
		commands.append(["desc", player_mon.nickname + " used " + player_mon.current_moves[move_ind] + "!", "attack"])
		commands.append(["player", player_mon.current_moves[move_ind] ])
		# picks a random move for the enemy and puts it in the commands list
		var enemy_move = enemy_mon.current_moves.pick_random()
		commands.append(["desc", "Enemy used " + enemy_move + "!", "brace"])
		commands.append(["enemy", enemy_move])
		# sets battle_prog to 0 so it starts the turn
		battle_prog = 0
	# otherwise appends enemy commands first
	else:
		# picks a random move for the enemy and puts it in the commands list
		var enemy_move = enemy_mon.current_moves.pick_random()
		commands.append(["desc", "Enemy used " + enemy_move + "!", "brace"])
		commands.append(["enemy", enemy_move])
		# puts the move used by the player in the commands list
		commands.append(["desc", player_mon.nickname + " used " + player_mon.current_moves[move_ind] + "!", "attack"])
		commands.append(["player", player_mon.current_moves[move_ind] ])
		# sets battle_prog to 0 so it starts the turn
		battle_prog = 0

func handle_turn(current_command):
	var enem_prev_health = enemy_mon.health
	var play_prev_health = player_mon.health
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
		if current_command[2] == "attack":
			player_mon.play_atk_anim()
			enemy_mon.play_brace_anim()
		elif current_command[2] == "brace":
			player_mon.play_brace_anim()
			enemy_mon.play_atk_anim()
		battle_prog += 1
	var test = enem_prev_health
	enemy_hp_bar.value = enemy_mon.health
	player_hp_bar.value = player_mon.health
	#print(battle_prog)

func handle_status():
	# if the status counter ticks down to 0, clears the status effect
	if player_mon.status_counter <= 0 && player_mon.status != "None":
		commands.append(["desc", player_mon.status + " wore off.", "idle"])
		player_mon.status = "None"
		#print(player_mon.status + str(player_mon.status_counter))
	# if the player has a status, counts down the timer by 1
	elif player_mon.status != "None":
		commands.append(["playerstatus", player_mon.status])
		player_mon.status_counter -= 1
		#print(player_mon.status + str(player_mon.status_counter))
	# if the status counter ticks down to 0, clears the status effect
	if enemy_mon.status_counter <= 0 && enemy_mon.status != "None":
		commands.append(["desc", "Enemy's " + enemy_mon.status + " wore off.", "idle"])
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

func change_player_mon(index):
	player_mon.visible = false
	player_mon = player_team[index]
	player_mon.global_position = player_spawn.global_position
	player_mon.visible = true
	if !(player_mon in mons_for_exp):
		mons_for_exp.append(player_mon)
	load_moves()

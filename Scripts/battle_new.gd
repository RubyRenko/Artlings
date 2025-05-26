extends Node3D

@onready var player_spawn = $PlayerMonSpawn
@onready var player_hp_bar = $CanvasLayer/PlayerHpBar
@onready var player_hp_nums = $CanvasLayer/PlayerHpBar/HpNums
@onready var player_name_label = $CanvasLayer/PlayerHpBar/Name
@onready var enemy_spawn = $EnemyMonSpawn
@onready var enemy_hp_bar = $CanvasLayer/EnemyHpBar
@onready var enemy_hp_nums = $CanvasLayer/EnemyHpBar/HpNums
@onready var enemy_name_label = $CanvasLayer/EnemyHpBar/Name

@onready var move_opt = $CanvasLayer/MoveOptions
@onready var battle_desc = $CanvasLayer/BattleDesc
@onready var battle_desc_box = $CanvasLayer/BattleDescBox
@onready var change_button = $CanvasLayer/ChangeArtling
@onready var autoplay_button = $CanvasLayer/AutoplayButton
@onready var party_screen = $CanvasLayer/Party
@onready var master_move_list = preload("res://move_list.tscn").instantiate()

@onready var turn_timer = $TurnTimer
@onready var click_icon = $CanvasLayer/ProgLabel
var can_click = true
static var auto = false

var player
var player_team : Array
var mons_for_exp : Array
var exp_gain = 100
var enemy_team : Array
var player_mon : Node3D
var enemy_mon : Node3D

var battle_prog = -1
var commands = []
var battle_won = false
var faint_switch = false
var changing_mons = false

func _ready():
	if auto:
		autoplay_button.button_pressed = true
	else:
		autoplay_button.button_pressed = false

func update_player_sprite():
	player_mon = player_team[0]
	player_mon.global_position = player_spawn.global_position
	player_mon.rotation = player_spawn.rotation
	player_mon.visible = true
	player_name_label.set_text(player_mon.nickname)
	player_hp_bar.max_value = player_mon.max_hp
	player_hp_bar.value = player_mon.health
	player_hp_nums.text = "%s / %s " % [player_mon.health, player_mon.max_hp]
	load_moves()

func update_enemy_sprite():
	enemy_mon = enemy_team[0]
	enemy_mon.global_position = enemy_spawn.global_position
	enemy_mon.rotation = enemy_spawn.rotation
	enemy_mon.visible = true
	if enemy_mon.is_in_group("2d"):
		enemy_mon.anim.flip_h = true
	enemy_name_label.set_text(enemy_mon.nickname)
	enemy_hp_bar.max_value = enemy_mon.max_hp
	enemy_hp_bar.value = enemy_mon.health
	enemy_hp_nums.text = "%s / %s " % [enemy_mon.health, enemy_mon.max_hp]
	
func load_mons(player_inp, enemy_inp):
	# sets the player to the input and player team with the first mon going into battle
	player = player_inp
	player_team = player_inp.team
	mons_for_exp.append(player_team[0])
	update_player_sprite()
	#print(player_mon.level)
	
	# sets the enemy mon to the input and puts it where it's supposed to be
	enemy_team = enemy_inp
	update_enemy_sprite()
	
	party_screen.update_battle_party(player_team)
	party_screen.visible = false
	#print(enemy_mon.level)

func load_moves():
	#print(player_mon.current_moves)
	move_opt.toggle_move_buttons(player_mon.current_moves)
	print(player_mon.current_moves)

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
	if Input.is_action_just_pressed("progress_battle") && can_click && !auto:
		continue_battle(battle_prog)
	
	# if the player or enemy has no more health
	# clears commands and sets battle prog to -2 so it can display win or lose text
	if player_mon.health <= 0 && battle_prog >= -1 && !changing_mons:
		var team_wiped = true
		changing_mons = true
		player_mon.fainted = true
		for mon in player_team:
			if mon.fainted == false:
				team_wiped = false
				break
		if team_wiped:
			commands = []
			battle_prog = -2
		else:
			commands = []
			faint_switch = true
			party_screen.update_battle_party(player_team)
			party_screen.visible = true
	elif enemy_mon.health <= 0 && battle_prog != -3 && !changing_mons:
		var team_wiped = true
		changing_mons = true
		var next_mon
		enemy_mon.fainted = true
		enemy_mon.visible = false
		for mon in enemy_team:
			if mon.fainted == false:
				team_wiped = false
				next_mon = mon
				break
		if team_wiped:
			battle_won = true
			commands = []
			battle_prog = -2
		else:
			commands = []
			commands.append(["desc", enemy_mon.nickname + " defeated! Opponent sends out " + next_mon.nickname + ".", "idle"])
			enemy_team[enemy_team.find(next_mon)] = enemy_team[0]
			enemy_team[0] = next_mon
			enemy_mon = enemy_team[0]
			update_enemy_sprite()
			changing_mons = false
			handle_turn(commands[0])

func _on_move_1_pressed():
	choose_move(0)
	handle_turn(commands[0])

func _on_move_2_pressed():
	choose_move(1)
	handle_turn(commands[0])

func _on_move_3_pressed():
	choose_move(2)
	handle_turn(commands[0])

func _on_move_4_pressed():
	choose_move(3)
	handle_turn(commands[0])

func choose_move(move_ind):
	# if the player is faster, appends player commands first
	if player_mon.speed >= enemy_mon.speed:
		# puts the move used by the player in the commands list
		commands.append(["desc", "Player " + player_mon.nickname + " used " + player_mon.current_moves[move_ind].capitalize() + "!", "attack"])
		commands.append(["player", player_mon.current_moves[move_ind] ])
		# picks a random move for the enemy and puts it in the commands list
		var enemy_move = enemy_mon.current_moves.pick_random()
		commands.append(["desc", "Enemy " + enemy_mon.nickname + " used " + enemy_move.capitalize() + "!", "brace"])
		commands.append(["enemy", enemy_move])
		commands.append(["status"])
		# sets battle_prog to 0 so it starts the turn
		battle_prog = 0
		click_icon.visible = true
	# otherwise appends enemy commands first
	else:
		# picks a random move for the enemy and puts it in the commands list
		var enemy_move = enemy_mon.current_moves.pick_random()
		commands.append(["desc", "Enemy " + enemy_mon.nickname + " used " + enemy_move.capitalize() + "!", "brace"])
		commands.append(["enemy", enemy_move])
		# puts the move used by the player in the commands list
		commands.append(["desc", "Player " + player_mon.nickname + " used " + player_mon.current_moves[move_ind].capitalize() + "!", "attack"])
		commands.append(["player", player_mon.current_moves[move_ind] ])
		commands.append(["status"])
		# sets battle_prog to 0 so it starts the turn
		battle_prog = 0
		click_icon.visible = true

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
	elif current_command[0] == "status":
		handle_status()
		battle_prog += 1
		if battle_prog < len(commands):
			continue_battle(battle_prog)
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
		elif current_command[2] == "idle":
			player_mon.play_idle_anim()
			enemy_mon.play_idle_anim()
		battle_prog += 1
	
	enemy_hp_bar.value = enemy_mon.health
	player_hp_bar.value = player_mon.health
	player_hp_nums.text = "%s / %s " % [player_mon.health, player_mon.max_hp]
	enemy_hp_nums.text = "%s / %s " % [enemy_mon.health, enemy_mon.max_hp]
	
	can_click = false
	turn_timer.start()
	click_icon.visible = false
	#print(commands)
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

func _on_back_button_pressed():
	party_screen.visible = false

func _on_change_artling_pressed():
	party_screen.update_battle_party(player_team)
	party_screen.visible = true

func choose_artling(artling_ind):
	party_screen.visible = false
	player_mon.visible = false
	player.swap_team(0, artling_ind)
	update_player_sprite()
	if !(player_mon in mons_for_exp):
		mons_for_exp.append(player_team[0])
	commands.append(["desc", "Swapped to " + player_mon.nickname + ".", "brace"])
	# picks a random move for the enemy and puts it in the commands list
	if !faint_switch:
		var enemy_move = enemy_mon.current_moves.pick_random()
		commands.append(["desc", "Enemy used " + enemy_move + "!", "brace"])
		commands.append(["enemy", enemy_move])
		battle_prog = 0
		faint_switch = false
	changing_mons = false
	handle_turn(commands[0])

func _on_artling_1_pressed():
	choose_artling(0)

func _on_artling_2_pressed():
	choose_artling(1)

func _on_artling_3_pressed():
	choose_artling(2)

func _on_artling_4_pressed():
	choose_artling(3)

func _on_artling_5_pressed():
	choose_artling(4)

func _on_artling_6_pressed():
	choose_artling(5)

func _on_turn_timer_timeout():
	can_click = true
	click_icon.visible = true
	if auto:
		continue_battle(battle_prog)

func continue_battle(prog):
# when trying to progress battle and one mon is lost
	if prog == -3: 
		queue_free()
	elif prog == -2:
		# disables buttons
		move_opt.disable_buttons()
		# shows text based on if battle was won or lost
		# adds exprience to player
		if battle_won:
			var win_text = "Battle won!"
			#print(mons_for_exp)
			for mon in mons_for_exp:
				#print(mon)
				var exp = exp_gain/len(mons_for_exp) * len(enemy_team)
				win_text += "\n" + mon.add_experience(exp)
			battle_desc.set_text(win_text)
			#print("Player level: " + str(player_mon.level))
		else:
			battle_desc.set_text("Battle lost...")
			#player_mon.add_experience(100)
			#print("Player level: " + str(player_mon.level))
		# resets the enemy and player mon health and makes them invisible
		for mon in enemy_team:
			mon.visible = false
			mon.health = mon.max_hp
			mon.fainted = false
		for mon in player_team:
			mon.visible = false
			mon.health = mon.max_hp
			mon.fainted = false
		player.inspo += 2
		# sets battle prog to -3 so the battle queues free and ends
		can_click = false
		turn_timer.start()
		click_icon.visible = false
		battle_prog = -3
	# goes down the list of commands and executes them when battle prog is positive
	elif prog > -1:
		var current_command = commands[battle_prog]
		#print(current_command)
		handle_turn(current_command)

func _on_autoplay_button_pressed():
	auto = !auto
	if auto:
		turn_timer.wait_time = 1.5
	else:
		turn_timer.wait_time = 1

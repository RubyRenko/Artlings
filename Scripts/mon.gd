extends Node3D
class_name Mon

# base stats
@export var max_hp : int
var health : int = max_hp
@export var strength : int
@export var defense : int
@export var intelligence : int
@export var mind : int
@export var speed : int
@export var element : String
@export var nickname : String

# move master list
@onready var master_move_list = load("res://move_list.tscn").instantiate()

# progression
var level = 1
var exp = 0

# dictionary of moves learned by the mon
var moves_list : Dictionary
# list of moves the artling can learn in the future
var learnable_moves : Array 
# current moves the artling has (capped at 4)
var current_moves : Array

# status effect vars
var status : String = "None"
var status_counter : int = 0
var fainted = false

#nodes the Artling should have
@onready var hp_bar = $HpBar
@onready var stat_screen = $ArtlingStats
@export var img : CompressedTexture2D

# handles the attack and returns a string describing the outcome
# target should be a mon and move should be usable move in the list
func attack(target, move):
	# checks that the target and move used is valid, otherwise does nothing
	if target.is_in_group("mon") && move in moves_list:
		#print("Commencing attack")
		# chooses attack and handles move accuracy
		# for different statuses that affect attack, this is where it goes
		var atk = moves_list[move]
		var acc = atk.accuracy
		var damage_range = atk.damage
		if status == "Blind":
			acc -= 20
			#print("affected by blind, accuracy: " + str(acc))
		elif status == "Soapy" && len(damage_range) == 2:
			damage_range = [atk.damage[0], atk.damage[0]]
		elif status == "Soapy" && len(damage_range) == 4:
			damage_range = [atk.damage[0], atk.damage[0], atk.damage[2], atk.damage[2]]
		
		# generates a random int form 0-100
		if randi_range(0, 100) <= acc:
			# if it's lower than accuracy, it hits
			if atk.dmg_type == "str":
				# calculates damage depending on the str stat
				var damage = randi_range(damage_range[0], damage_range[1])
				var final_dmg = calculate_phys_damage(damage)
				if atk.effect[0] != 0:
					# if the affect isn't blank, splits the effect string into
					# what the status is and the turns applied 
					target.status = atk.effect[1]
					target.status_counter = atk.effect[0]
				return target.take_phys_damage(final_dmg)
			
			elif atk.dmg_type == "int":
				# calculates damage depending on the int stat
				var damage = randi_range(damage_range[0], damage_range[1])
				var final_dmg = calculate_mnd_damage(damage)
				if atk.effect[0] != 0:
					# if the affect isn't blank, applies status and counter
					target.status = atk.effect[1]
					target.status_counter = atk.effect[0]
				return target.take_mnd_damage(final_dmg)
			
			elif atk.dmg_type == "str/mnd":
				# calculates damage depending on the str stat
				# with defense being mnd stat
				var damage = randi_range(damage_range[0], damage_range[1])
				var final_dmg = calculate_phys_damage(damage)
				if atk.effect[0] != 0:
					# if the affect isn't blank, applies status and counter
					target.status = atk.effect[1]
					target.status_counter = atk.effect[0]
				return target.take_mnd_damage(final_dmg)
			
			elif atk.dmg_type == "int/def":
				# calculates damage depending on the int stat
				# with defense being def stat
				var damage = randi_range(damage_range[0], damage_range[1])
				var final_dmg = calculate_mnd_damage(damage)
				if atk.effect[0] != 0:
					# if the affect isn't blank, applies status and counter
					target.status = atk.effect[1]
					target.status_counter = atk.effect[0]
				return target.take_phys_damage(final_dmg)
			
			elif atk.dmg_type == "int/self":
				var damage = randi_range(damage_range[0], damage_range[1])
				var final_dmg = calculate_mnd_damage(damage)
				if atk.effect[0] != 0:
					# if the affect isn't blank, applies status and counter
					target.status = atk.effect[1]
					target.status_counter = atk.effect[0]
				var self_dmg = randi_range(damage_range[2], damage_range[3])
				var final_self_dmg = calculate_mnd_damage(self_dmg)
				
				return target.take_mnd_damage(final_dmg) + "\n" +take_mnd_damage(final_self_dmg)
			
			elif atk.dmg_type == "str/self":
				var damage = randi_range(damage_range[0], damage_range[1])
				var final_dmg = calculate_phys_damage(damage)
				if atk.effect[0] != 0:
					# if the affect isn't blank, applies status and counter
					target.status = atk.effect[1]
					target.status_counter = atk.effect[0]
				
				var self_dmg = randi_range(damage_range[2], damage_range[3])
				var final_self_dmg = calculate_phys_damage(self_dmg)
				return target.take_phys_damage(final_dmg) + "\n" +take_phys_damage(final_self_dmg)
			
			elif atk.dmg_type == "self":
				var damage = randi_range(atk.damage[0], atk.damage[1])
				var final_dmg = calculate_mnd_damage(damage)
				if atk.effect[0] != 0:
					status = atk.effect[1]
					status_counter = atk.effect[0]
				return take_mnd_damage(final_dmg)
		else:
			# if it's higher then it misses
			#print("Missed!")
			return "Missed!"

func calculate_phys_damage(amount):
	# calculates physical damage based on mon strength
	amount = (amount * strength)/30.0
	return amount

func calculate_mnd_damage(amount):
	# calculates physical damage based on mon intelligence
	amount = (amount * intelligence)/30.0
	return amount

# takes damage and returns string of how much damage was taken
func take_phys_damage(amount):
	if amount < 0:
		#if amount is negative (healing), then minuses so it adds health
		amount = floori(amount)
		health -= amount
		if health > max_hp:
			health = max_hp
		var output_line = name + " healed " + str(-amount) + " damage!\nHealth remaining " + str(health) + "."
		return output_line
	else:
		# calculates the physical damage taken based on mon defense
		amount -= defense/5.0
		amount = ceili(amount)
		if amount < 0:
			amount = 0
		health -= amount
		#print("Took " + str(amount) + " damage!\nHealth remaining " + str(health) + ".")
		var output_line = name + " took " + str(amount) + " damage!\nHealth remaining " + str(health) + "."
		return output_line

# takes damage and returns string of how much damage was taken
func take_mnd_damage(amount):
	if amount < 0:
		#if amount is negative (healing), then minuses so it adds health
		amount = floori(amount)
		health -= amount
		if health > max_hp:
			health = max_hp
		var output_line = name + " healed " + str(-amount) + " damage!\nHealth remaining " + str(health) + "."
		return output_line
	else:
		# calculates the physical damage taken based on mon defense
		amount -= mind/5.0
		amount = ceili(amount)
		if amount < 0:
			amount = 0
		health -= amount
		#print("Took " + str(amount) + " damage!\nHealth remaining " + str(health) + ".")
		var output_line = name + " took " + str(amount) + " damage!\nHealth remaining " + str(health) + "."
		return output_line

# handles status damage or effects
func take_status():
	#print(status)
	if status == "Burn":
		var damage = ceili(health/20.0)
		health -= damage
		if randi_range(0,10) <= defense:
			#print("burn cures faster")
			status_counter -= 1
		return name + " takes burn damage."
	elif status == "Poison":
		var damage = ceili(health/20.0)
		if randi_range(0,10) <= mind:
			#print("poison cures faster")
			status_counter -= 1
		health -= damage
		return name + " takes poison damage."
	elif status == "Blind":
		return name + " is blinded."
	elif status == "Soapy":
		return name + " is soapy."
	elif status == "Bubble":
		var heal = ceili(health/20)
		health += heal
		if health > max_hp:
			health = max_hp
		return name + " heals a little."

# sets all the main stats
func set_stats(hp, str, def, intel, mnd, spd):
	max_hp = hp
	strength = str
	defense = def
	intelligence = intel
	mind = mnd
	speed = spd

# adds values to hp, should be used for level ups
func add_stats(hp, str, def, intel, mnd, spd):
	max_hp += hp
	strength += str
	defense += def
	intelligence += intel
	mind += mnd
	speed += spd

# load moves from the master list and adds it to the move_list
func load_move(move):
	moves_list[move.name] = move
	learnable_moves.pop_at(learnable_moves.find(move.name))
	if len(current_moves) < 4:
		current_moves.append(move.name)

# adds experience and levels up 
func add_experience(amount):
	exp += amount
	#level up
	if exp >= 100:
		level += 1
		#right now, stats are random, but in the future might be able to be customized by a growth variable
		add_stats(randi_range(1,10), randi_range(0,5), randi_range(0,5), randi_range(0,5), randi_range(0,5), randi_range(0,5))
		health = max_hp
		if len(learnable_moves) > 0:
			var to_learn = learnable_moves[0]
			print(to_learn)
			load_move(master_move_list.get_move(to_learn))
			print(current_moves)
			print(moves_list)
		exp -= 100

func setup_stat_screen():
	stat_screen.load_moves(current_moves, moves_list.keys())
	stat_screen.set_name_text(nickname)
	stat_screen.set_level_text(level)
	stat_screen.set_stat_text(health, max_hp, strength, defense, intelligence, mind, speed)
	stat_screen.set_img(img)
	stat_screen.leader_button.pressed.connect(_leader_button_pressed)
	stat_screen.close_button.pressed.connect(_stat_exit_pressed)

func update_stat_screen():
	stat_screen.load_moves(current_moves, moves_list.keys())
	stat_screen.set_name_text(nickname)
	stat_screen.set_level_text(level)
	stat_screen.set_stat_text(health, max_hp, strength, defense, intelligence, mind, speed)
	stat_screen.set_img(img)

func update_from_stat_screen():
	current_moves = stat_screen.chosen_moves

func _leader_button_pressed():
	print("leader button pressed!")
	var player = get_parent().get_parent()
	var ind = player.team.find(self)
	player.swap_team(0, ind)
	#print(current_moves, stat_screen.chosen_moves)
	update_from_stat_screen()
	player.hide_screens()
	player.show_party_screen()

func _stat_exit_pressed():
	var player = get_parent().get_parent()
	#print(current_moves, stat_screen.chosen_moves)
	update_from_stat_screen()
	player.hide_screens()
	player.show_party_screen()

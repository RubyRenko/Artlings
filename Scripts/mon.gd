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
@export var species : String
@export var stat_growth = [5, 5, 5, 5, 5, 5]
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
	if target.is_in_group("mon"):
		#print("Commencing attack")
		# chooses attack and handles move accuracy
		# for different statuses that affect attack, this is where it goes
		var battle_text = ""
		var atk = moves_list[move]
		var acc = atk.accuracy
		var damage_range = atk.damage
		if status == "Blind":
			acc -= 20
			#print("affected by blind, accuracy: " + str(acc))
		elif status == "Focusing":
			acc = 100
		elif status == "Soapy":
			damage_range[0] -= atk.damage[0]/5
			damage_range[1] = atk.damage[0]
		elif status == "Confused":
			var new_atk = current_moves.pick_random()
			battle_text += "%s is confused, used %s instead.\n" % [nickname, new_atk]
			atk = moves_list[new_atk]
		elif status == "Poked":
			damage_range[0] -= damage_range[0]/10
			damage_range[1] -= damage_range[0]/10
		
		if target.status == "Hidden":
			acc -= 30
		elif target.status == "Flattened":
			damage_range[0] = atk.damage[1]
			damage_range[1] = atk.damage[1]+(atk.damage[1]/5)
		#print(atk)
		# generates a random int form 0-100
		if randi_range(0, 100) <= acc:
			# if it's lower than accuracy, it hits
			if atk.dmg_type == "str":
				# calculates damage depending on the str stat
				battle_text += atk.battle_text % [nickname, target.nickname]
				var damage = randi_range(damage_range[0], damage_range[1])
				var final_dmg = calculate_phys_damage(damage)
				if atk.effect[1] == "Cure":
					target.status = "None"
					target.status_counter = 0
				elif atk.effect[0] != 0:
					if apply_effect(target, atk.effect):
						battle_text = battle_text + "\nApplied " + atk.effect[1] + "."
					else:
						battle_text = battle_text + "\n" + target.nickname + " is already " + target.status + "."
				target.take_phys_damage(final_dmg)
				return battle_text
			
			elif atk.dmg_type == "int":
				# calculates damage depending on the int stat
				battle_text += atk.battle_text % [nickname, target.nickname]
				var damage = randi_range(damage_range[0], damage_range[1])
				var final_dmg = calculate_mnd_damage(damage)
				if atk.effect[1] == "Cure":
					target.status = "None"
					target.status_counter = 0
				elif atk.effect[0] != 0:
					if apply_effect(target, atk.effect):
						battle_text = battle_text + "\nApplied " + atk.effect[1] + "."
					else:
						battle_text = battle_text + "\n" + target.nickname + " is already " + target.status + "."
				target.take_mnd_damage(final_dmg)
				return battle_text
			
			elif atk.dmg_type == "str/mnd":
				# calculates damage depending on the str stat
				# with defense being mnd stat
				battle_text += atk.battle_text % [nickname, target.nickname]
				var damage = randi_range(damage_range[0], damage_range[1])
				var final_dmg = calculate_phys_damage(damage)
				if atk.effect[1] == "Cure":
					target.status = "None"
					target.status_counter = 0
				elif atk.effect[0] != 0:
					if apply_effect(target, atk.effect):
						battle_text += "\nApplied " + atk.effect[1] + "to" + target.nickname + "."
					else:
						battle_text += "\n" + target.nickname + " is already " + target.status + "."
				target.take_mnd_damage(final_dmg)
				return battle_text
			
			elif atk.dmg_type == "int/def":
				# calculates damage depending on the int stat
				# with defense being def stat
				battle_text += atk.battle_text % [nickname, target.nickname]
				var damage = randi_range(damage_range[0], damage_range[1])
				var final_dmg = calculate_mnd_damage(damage)
				if atk.effect[1] == "Cure":
					target.status = "None"
					target.status_counter = 0
				elif atk.effect[0] != 0:
					if apply_effect(target, atk.effect):
						battle_text += "\nApplied " + atk.effect[1] + " to " + target.nickname + "."
					else:
						battle_text += "\n" + target.nickname + " is already " + target.status + "."
				target.take_phys_damage(final_dmg)
				return battle_text
			
			elif atk.dmg_type == "int/self":
				battle_text += atk.battle_text % [nickname, target.nickname]
				var damage = randi_range(damage_range[0], damage_range[1])
				var final_dmg = calculate_mnd_damage(damage)
				if atk.effect[1] == "Cure":
					target.status = "None"
					target.status_counter = 0
				elif atk.effect[0] != 0:
					if apply_effect(target, atk.effect):
						battle_text += "\nApplied " + atk.effect[1]  + " to " + target.nickname + "."
					else:
						battle_text += "\n" + target.nickname + " is already " + target.status + "."
					if apply_effect(self, atk.effect):
						battle_text = battle_text + "\nApplied " + atk.effect[1]  + " to " + nickname + "."
					else:
						battle_text = battle_text + "\n" + nickname + " is already " + status + "."
				var self_dmg = randi_range(damage_range[2], damage_range[3])
				var final_self_dmg = calculate_mnd_damage(self_dmg)
				target.take_mnd_damage(final_dmg)
				take_mnd_damage(final_self_dmg)
				return battle_text
			
			elif atk.dmg_type == "str/self":
				battle_text += atk.battle_text % [nickname, target.nickname]
				var damage = randi_range(damage_range[0], damage_range[1])
				var final_dmg = calculate_phys_damage(damage)
				if atk.effect[1] == "Cure":
					target.status = "None"
					target.status_counter = 0
				elif atk.effect[0] != 0:
					if apply_effect(target, atk.effect):
						battle_text += "\nApplied " + atk.effect[1] + " to " + target.nickname + "."
					else:
						battle_text += "\n" + target.nickname + " is already " + target.status + "."
					if apply_effect(self, atk.effect):
						battle_text += "\nApplied " + atk.effect[1] + " to " + nickname + "."
					else:
						battle_text += "\n" + nickname + " is already " + status + "."
				var self_dmg = randi_range(damage_range[2], damage_range[3])
				var final_self_dmg = calculate_phys_damage(self_dmg)
				target.take_phys_damage(final_dmg)
				take_phys_damage(final_self_dmg)
				return battle_text
			
			elif atk.dmg_type == "self":
				battle_text += atk.battle_text % [nickname]
				var damage = randi_range(atk.damage[0], atk.damage[1])
				var final_dmg = calculate_mnd_damage(damage)
				if atk.effect[1] == "Cure":
					target.status = "None"
					target.status_counter = 0
				elif atk.effect[0] != 0:
					if apply_effect(self, atk.effect):
						battle_text += "\nApplied " + atk.effect[1] + " to " + nickname + "."
					else:
						battle_text += "\n" + nickname + " is already " + status + "."
				take_mnd_damage(final_dmg)
				return battle_text
		else:
			# if it's higher then it misses
			#print("Missed!")
			return battle_text + " Missed!"

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
		var output_line = "Healed " + str(-amount) + " damage!\nHealth remaining " + str(health) + "."
		return output_line
	else:
		# calculates the physical damage taken based on mon defense
		amount -= defense/5.0
		amount = ceili(amount)
		if amount < 0:
			amount = 0
		health -= amount
		#print("Took " + str(amount) + " damage!\nHealth remaining " + str(health) + ".")
		var output_line = "Dealt " + str(amount) + " damage!\nHealth remaining " + str(health) + "."
		return output_line

# takes damage and returns string of how much damage was taken
func take_mnd_damage(amount):
	if amount < 0:
		#if amount is negative (healing), then minuses so it adds health
		amount = floori(amount)
		health -= amount
		if health > max_hp:
			health = max_hp
		var output_line = "Healed " + str(-amount) + " damage!\nHealth remaining " + str(health) + "."
		return output_line
	else:
		# calculates the physical damage taken based on mon defense
		amount -= mind/5.0
		amount = ceili(amount)
		if amount < 0:
			amount = 0
		health -= amount
		#print("Took " + str(amount) + " damage!\nHealth remaining " + str(health) + ".")
		var output_line = "Dealt " + str(amount) + " damage!\nHealth remaining " + str(health) + "."
		return output_line

func apply_effect(target, effect):
	if target.status == "None":
		target.status = effect[1]
		target.status_counter = effect[0]
		return true
	else:
		return false

# handles status damage or effects
func take_status():
	#print(status)
	if status == "Burned":
		var damage = ceili(health/20.0)
		health -= damage
		if randi_range(0,10) <= defense:
			#print("burn cures faster")
			status_counter -= 1
		return nickname + " takes burn damage."
	elif status == "Poisoned":
		var damage = ceili(health/20.0)
		if randi_range(0,10) <= mind:
			#print("poison cures faster")
			status_counter -= 1
		health -= damage
		return nickname + " takes poison damage."
	elif status == "Poked":
		var damage = ceili(health/16.0)
		if randi_range(0,50) <= defense:
			damage -= 2
		health -= damage
		return nickname + " gets hurt from being poked."
	elif status == "Trapped":
		var damage = ceili(health/16.0)
		if randi_range(0,50) <= strength:
			damage -= 2
		health -= damage
		return nickname + " gets hurt from being trapped."
	elif status == "Blind":
		return nickname + " is blinded."
	elif status == "Soapy":
		return nickname + " is soapy."
	elif status == "Bubbled":
		var heal = ceili(health/12)
		health += heal
		if health > max_hp:
			health = max_hp
		return nickname + " heals a little."
	elif status == "Focusing":
		return nickname + " is focusing."
	elif status == "Confused":
		return nickname + " is confused."
	elif status == "Hidden":
		return nickname + " is hidden."
	elif status == "Flattened":
		return nickname + " is flattened."
	else:
		return "placeholder status"

# sets all the main stats
func set_stats(hp, str, def, intel, mnd, spd):
	max_hp = hp
	health = hp
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

# takes a move class and adds it to the move_list
func load_move(move):
	#print(move)
	learnable_moves.pop_at(learnable_moves.find(move.name))
	moves_list[move.name] = move
	if len(current_moves) < 4:
		current_moves.append(move.name)

# adds experience and levels up 
func add_experience(amount):
	exp += amount
	var level_text = "" 
	#level up
	while exp >= 100:
		level_text += nickname + " leveled up! "
		level += 1
		#right now, stats are random, but in the future might be able to be customized by a growth variable
		add_stats(randi_range(1,stat_growth[0]), randi_range(0, stat_growth[1]), randi_range(0, stat_growth[2]),\
		randi_range(0,stat_growth[3]), randi_range(0,stat_growth[4]), randi_range(0,stat_growth[5]))
		health = max_hp
		if len(learnable_moves) > 0:
			var to_learn = learnable_moves[0]
			#print(to_learn)
			load_move(master_move_list.get_move(to_learn))
			#print(current_moves)
			#print(moves_list)
			level_text += "Learned " + to_learn.capitalize() + ". "
		exp -= 100
	return level_text

func setup_stat_screen():
	stat_screen.load_moves(current_moves, moves_list.keys())
	stat_screen.set_name_text(nickname)
	stat_screen.set_level_text(level)
	stat_screen.set_stat_text(max_hp, strength, defense, intelligence, mind, speed)
	stat_screen.set_img(img)
	stat_screen.set_bars(health, max_hp, exp)

func update_stat_screen():
	stat_screen.load_moves(current_moves, moves_list.keys())
	stat_screen.set_name_text(nickname)
	stat_screen.set_level_text(level)
	stat_screen.set_stat_text(max_hp, strength, defense, intelligence, mind, speed)
	stat_screen.set_img(img)
	stat_screen.set_bars(health, max_hp, exp)

func update_from_stat_screen():
	current_moves = stat_screen.chosen_moves

"func _stat_exit_pressed():
	var player = get_parent().get_parent()
	#print(current_moves, stat_screen.chosen_moves)
	update_from_stat_screen()
	player.hide_screens()
	player.show_party_screen()"

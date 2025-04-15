extends Node3D
class_name Mon

#base stats
@export var max_hp : int
var health : int = max_hp
@export var strength : int
@export var defense : int
@export var intelligence : int
@export var mind : int
@export var speed : int
@export var element : String

#master list
@onready var master_move_list = load("res://move_list.tscn")

#progression
var level = 1
var exp = 0
var moves_list : Dictionary
var learnable_moves : Array 
var status : String = "None"
var status_counter : int = 0

# handles the attack and returns a string describing the outcome
#target should be a mon and move should be usable move in the list
func attack(target, move):
	# checks that the target and move used is valid, otherwise does nothing
	if target.is_in_group("mon") && move in moves_list:
		#print("Commencing attack")
		# chooses attack and handles move accuracy
		# for different statuses that affect attack, this is where it goes
		var atk = moves_list[move]
		var acc = atk.accuracy
		if status == "Blind":
			acc -= 20
			#print("affected by blind, accuracy: " + str(acc))
		
		# generates a random int form 0-100
		if randi_range(0, 100) <= acc:
			# if it's lower than accuracy, it hits
			if atk.dmg_type == "str":
				# calculates damage depending on the type stat
				var final_dmg = calculate_phys_damage(atk.damage)
				if atk.effect != "":
					#print(atk.effect.substr(0,-2))
					#print(atk.effect.substr(0, len(atk.effect)-1))
					#print(atk.effect.substr(len(atk.effect)-1))
					# if the affect isn't blank, splits the effect string into
					# what the status is and the turns applied 
					target.status = atk.effect.substr(0, len(atk.effect)-1)
					target.status_counter = int(atk.effect.substr(len(atk.effect)-1))
				return target.take_phys_damage(final_dmg)
			elif atk.dmg_type == "int":
				# calculates damage depending on the type stat
				var final_dmg = calculate_mnd_damage(atk.damage)
				if atk.effect != "":
					#print("Applying effect " + atk.effect)
					print(atk.effect.substr(0, len(atk.effect)-1))
					print(atk.effect.substr(len(atk.effect)-1))
					# if the affect isn't blank, splits the effect string into
					# what the status is and the turns applied 
					target.status = atk.effect.substr(0, len(atk.effect)-1)
					target.status_counter = int(atk.effect.substr(len(atk.effect)-1))
				return target.take_mnd_damage(final_dmg)
		else:
			# if it's higher than it misses
			#print("Missed!")
			return "Missed!"

func calculate_phys_damage(amount):
	# calculates physical damage based on mon strength
	# also adds a slight bit of randomn variation
	amount = (amount * strength)/30.0
	amount += randf_range(-amount/20, amount/20)
	#print(amount)
	return amount

func calculate_mnd_damage(amount):
	# calculates physical damage based on mon intelligence
	# also adds a slight bit of randomn variation
	amount = (amount * intelligence)/30.0
	amount += randf_range(-amount/20, amount/20)
	#print(amount)
	return amount

# takes damage and returns string of how much damage was taken
func take_phys_damage(amount):
	# calculates the physical damage taken based on mon defense
	amount -= defense/5.0
	amount = ceili(amount)
	if amount > 0:
		health -= amount
	
	#print("Took " + str(amount) + " damage!\nHealth remaining " + str(health) + ".")
	var output_line = "Took " + str(amount) + " damage!\nHealth remaining " + str(health) + "."
	return output_line

# takes damage and returns string of how much damage was taken
func take_mnd_damage(amount):
	# calculates the physical damage taken based on mon mind
	amount -= mind/5.0
	amount = ceili(amount)
	if amount > 0:
		health -= amount
	
	#print("Took " + str(amount) + " damage!\nHealth remaining " + str(health) + ".")
	var output_line = "Took " + str(amount) + " damage!\nHealth remaining " + str(health) + "."
	return output_line

# handles status damage or effects
func take_status(status):
	print(status)
	if status == "Burn":
		var damage = ceili(health/20.0)
		health -= damage
		if randi_range(0,10) <= defense:
			print("burn cures faster")
			status_counter -= 1
		return name + " takes burn damage."
	elif status == "Poison":
		var damage = ceili(health/20.0)
		if randi_range(0,10) <= mind:
			print("poison cures faster")
			status_counter -= 1
		health -= damage
		return name + " takes poison damage."
	elif status == "Blind":
		return name + " is blinded."

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
	if move.name in learnable_moves && len(moves_list) < 4:
		moves_list[move.name] = move

# adds experience and levels up 
func add_experience(amount):
	exp += amount
	#level up
	if exp >= 100:
		level += 1
		#right now, stats are random, but in the future might be able to be customized by a growth variable
		add_stats(randi_range(1,10), randi_range(0,5), randi_range(0,5), randi_range(0,5), randi_range(0,5), randi_range(0,5))
		exp -= 100

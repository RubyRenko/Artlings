extends Node2D
class_name Mon

#stats
static var max_hp : int
var health : int = max_hp
static var strength : int
static var defense : int
static var intelligence : int
static var mind : int
static var speed : int

#base stats
@export var base_hp : int
@export var base_str : int
@export var base_def : int
@export var base_int : int
@export var base_mnd : int
@export var base_spd : int
@export var element : String

#master list
@onready var master_move_list = load("res://move_list.tscn")

#progression
static var level = 1
static var exp = 0
var moves_list : Dictionary
var learnable_moves : Array 
var status : String = "None"
var status_counter : int = 0

func attack(target, move):
	if target.is_in_group("mon") && move in moves_list:
		#print("Commencing attack")
		var atk = moves_list[move]
		var acc = atk.accuracy
		if status == "Blind":
			acc -= 20
			print("affected by blind, accuracy: " + str(acc))
		
		if randi_range(0, 100) <= acc:
			if atk.dmg_type == "str":
				var final_dmg = calculate_phys_damage(atk.damage)
				if atk.effect != "":
					#print(atk.effect.substr(0,-2))
					print(atk.effect.substr(0, len(atk.effect)-1))
					print(atk.effect.substr(len(atk.effect)-1))
					target.status = atk.effect.substr(0, len(atk.effect)-1)
					target.status_counter = int(atk.effect.substr(len(atk.effect)-1))
				return target.take_phys_damage(final_dmg)
			elif atk.dmg_type == "int":
				var final_dmg = calculate_mnd_damage(atk.damage)
				if atk.effect != "":
					#print("Applying effect " + atk.effect)
					print(atk.effect.substr(0, len(atk.effect)-1))
					print(atk.effect.substr(len(atk.effect)-1))
					target.status = atk.effect.substr(0, len(atk.effect)-1)
					target.status_counter = int(atk.effect.substr(len(atk.effect)-1))
				return target.take_mnd_damage(final_dmg)
		else:
			#print("Missed!")
			return "Missed!"

func calculate_phys_damage(amount):
	amount = amount * strength/5.0
	return amount

func calculate_mnd_damage(amount):
	amount = amount * intelligence/5.0
	return amount

func take_phys_damage(amount):
	amount -= ceili(defense/5.0)
	if amount > 0:
		health -= amount
	#print("Took " + str(amount) + " damage!\nHealth remaining " + str(health) + ".")
	var output_line = "Took " + str(amount) + " damage!\nHealth remaining " + str(health) + "."
	return output_line

func take_mnd_damage(amount):
	amount -= ceili(mind/5.0)
	if amount > 0:
		health -= amount
	#print("Took " + str(amount) + " damage!\nHealth remaining " + str(health) + ".")
	var output_line = "Took " + str(amount) + " damage!\nHealth remaining " + str(health) + "."
	return output_line

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

func set_stats(hp, str, def, intel, mnd, spd):
	max_hp = hp
	strength = str
	defense = def
	intelligence = intel
	mind = mnd
	speed = spd

func load_move(move):
	if move.name in learnable_moves && len(moves_list) < 4:
		moves_list[move.name] = move

func add_experience(amount):
	exp += amount
	#level up
	if exp >= 100:
		level += 1
		max_hp += randi_range(0, 5)
		health = max_hp
		strength += randi_range(0, 5)
		defense += randi_range(0, 5)
		intelligence += randi_range(0, 5)
		mind += randi_range(0, 5)
		speed += randi_range(0, 5)
		exp -= 100

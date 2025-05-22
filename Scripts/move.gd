extends Node
class_name Move

#stats
@export var damage = [0, 0]
@export var accuracy : int
@export var type : String
@export var dmg_type : String
@export var effect = [0, "None"]
@export var desc : String
@export var battle_text : String

func _to_string():
	# formats all stats into a 3 line string
	var attack_type : String = ""
	var av_dmg_str : String = ""
	if dmg_type == "int":
		attack_type = "Intelligence"
		av_dmg_str = format_dmg(damage)
	elif dmg_type == "int/self":
		attack_type = "Intelligence"
		av_dmg_str = format_dmg(damage)
	elif dmg_type == "int/def":
		attack_type = "Intelligence"
		av_dmg_str = format_dmg(damage)
	elif dmg_type == "str":
		attack_type = "Strength"
		av_dmg_str = format_dmg(damage)
	elif dmg_type == "str/self":
		attack_type = "Strength"
		av_dmg_str = format_dmg(damage)
	elif dmg_type == "str/mnd":
		attack_type = "Strength"
		av_dmg_str = format_dmg(damage)
	elif dmg_type == "self":
		attack_type = "Self"
		av_dmg_str = format_dmg(damage)
	var format = "%s (%s)\n%s   Accuracy: %s\n%s" % [name.capitalize(), attack_type, av_dmg_str, accuracy, desc]
	return format

func format_dmg(damage_array):
	if len(damage_array) == 4:
		var return_str : String
		if damage_array[0] < 0:
			return_str = "Healing: " + str( int( abs( (damage[0] + damage[1]) / 2) ) )
		else:
			return_str = "Damage: " + str( int( (damage[0] + damage[1]) / 2 ) )
		if damage_array[2] < 0:
			return return_str + "   Healing: " + str( int( abs((damage[2] + damage[3]) / 2)) )
		elif damage_array[2] == 0:
			return return_str
		else:
			return return_str + "   Recoil: " + str( int( (damage[2] + damage[3]) / 2) )
	else:
		if damage_array[0] < 0:
			return "Healing: " + str( int( abs( (damage[0] + damage[1]) / 2) ) )
		else:
			return "Damage: " + str( int( (damage[0] + damage[1]) / 2 ) )
func set_stats(dmg, acc, typ, nam):
	# manually set the stats of a move
	damage = dmg
	accuracy = acc
	type = typ
	name = nam

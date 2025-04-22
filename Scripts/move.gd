extends Node
class_name Move

#stats
@export var damage = [0, 0]
@export var accuracy : int
@export var type : String
@export var dmg_type : String
@export var effect = [0, "None"]
@export var desc : String

func _to_string():
	return "%s (%s)\nDamage: %s (%s)         Accuracy: %s\n%s" %\
	 [name.capitalize(), type.capitalize(), damage, dmg_type, accuracy, desc]

func set_stats(dmg, acc, typ, nam):
	damage = dmg
	accuracy = acc
	type = typ
	name = nam

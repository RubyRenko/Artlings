extends Node
class_name Move

#stats
@export var damage = [0, 0]
@export var accuracy : int
@export var type : String
@export var dmg_type : String
@export var effect = [0, "None"]
@export var desc : String
var format_string = "%s (%s)\nDamage: %s (%s)\n%s\nAccuracy: %s"

func _to_string():
	return format_string % [name.capitalize(), type.capitalize(), damage, dmg_type, desc, accuracy]

func set_stats(dmg, acc, typ, nam):
	damage = dmg
	accuracy = acc
	type = typ
	name = nam

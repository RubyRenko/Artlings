extends Label

# Called when the node enters the scene tree for the first time.
func _ready():
	var basic_atk = Move.new()
	basic_atk.damage = 10
	basic_atk.accuracy = 90
	basic_atk.type = "normal"
	basic_atk.name = "basic attack"
	set_text(basic_atk.to_string())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

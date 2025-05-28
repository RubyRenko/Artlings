extends Panel

@onready var inspiration_text = $InspoLabel
@onready var color_text = $ColorLabel
@onready var create_button = $CreateArtling
@onready var name_edit = $NameEdit
@onready var player = get_parent().get_parent()
var new_artling_name : String
var r = 0
var o = 0
var y = 0
var g = 0
var b = 0
var v = 0
var total_color = 0
var inspo_cost = 2

func _process(_delta):
	inspiration_text.set_text("Current Inspiration: %s\nInspiration needed: %s" % [player.inspo, inspo_cost])
	color_text.set_text("Current colors\nR:%s O:%s Y:%s G:%s B:%s V:%s" % [r, o, y, g, b, v])
	new_artling_name = name_edit.text

func setup_screen():
	name_edit.text = ""
	create_button.text = "Create Artling"
	inspo_cost = len(player.team) * 2
	clear_colors()

func calculate_artling():
	if r == 1 && b == 1 && y == 1:
		return "Inkit"
	elif r == 6:
		return "Bapig"
	elif v == 6:
		return "Hatguy"
	elif b >= 2 && g >= 1:
		return "Dewphin"
	elif r >= 3:
		return "Wurm"
	else:
		return ArtlingsMasterlist.new().get_random_artling_name()

func clear_colors():
	r = 0
	o = 0
	y = 0
	g = 0
	b = 0
	v = 0
	total_color = 0

func _on_color_clear_pressed():
	clear_colors()

func _on_paint_blue_button_pressed():
	if total_color < 6:
		b += 1
		total_color += 1

func _on_paint_green_button_pressed():
	if total_color < 6:
		g += 1
		total_color += 1

func _on_paint_purple_button_pressed():
	if total_color < 6:
		v += 1
		total_color += 1

func _on_paint_orange_button_pressed():
	if total_color < 6:
		o += 1
		total_color += 1

func _on_paint_red_button_pressed():
	if total_color < 6:
		r += 1
		total_color += 1

func _on_paint_yellow_button_pressed():
	if total_color < 5:
		y += 1
		total_color += 1

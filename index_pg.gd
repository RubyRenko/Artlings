extends Panel

@onready var name_label = $Name
@onready var img = $Picture
@onready var desc_label = $Desc
@onready var artist_label = $ArtistCredit
@onready var craft_label = $CraftRecipe
@onready var move_label = $Moveset

func update_info(artling_name, image, desc, artist_credit, craft, moveset):
	show_info()
	name_label.text = artling_name
	img.texture = image
	desc_label.text = desc
	artist_label.text = artist_credit
	craft_label.text = craft
	move_label.text = ""
	for move in moveset:
		move_label.text += move + "\n"

func hide_info():
	for node in get_children():
		node.visible = false

func show_info():
	for node in get_children():
		node.visible = true

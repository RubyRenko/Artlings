extends Panel

@onready var name_label = $Name
@onready var img = $Picture
@onready var desc_label = $Desc
@onready var artist_label = $ArtistCredit
@onready var craft_label = $CraftRecipe

func update_info(artling_name, image, desc, artist_credit, craft):
	name_label.text = artling_name
	img.texture = image
	desc_label.text = desc
	artist_label.text = artist_credit
	craft_label.text = craft

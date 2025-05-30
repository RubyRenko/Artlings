extends Panel

@onready var text = $ConfirmText
@onready var nickname = $NameEdit
@onready var image_dis = $ArtlingImg

func setup_confirm(artling):
	image_dis.texture = artling.img
	text.text = "You made %s!" % artling.nickname
	nickname.text

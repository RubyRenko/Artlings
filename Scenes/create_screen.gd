extends Panel

@onready var inspiration_text = $Inspiration
@onready var create_button = $CreateArtling
@onready var name_edit = $NameEdit
var new_artling_name : String

func _process(_delta):
	inspiration_text.set_text("Current Inspiration: %s\nInspiration needed: 2" % str(get_parent().inspo))
	new_artling_name = name_edit.text

func setup_screen():
	name_edit.text = ""
	create_button.text = "Create Artling"

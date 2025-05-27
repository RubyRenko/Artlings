extends Panel

@onready var table_contents_name = $ToCNames
@onready var table_contents_pg = $ToCPages
@onready var index_buttons = $IndexTableButtons
@onready var index_pgs = $ArtlingIndexPg

var artlings_discovered = ["Inkit", "Dewphin", "Wurm"]

func update_table_text():
	var updated_name_str = ""
	var updated_pg_str = ""
	for i in len(artlings_discovered):
		updated_name_str += artlings_discovered[i] + "\n"
		updated_pg_str += str(i) + "\n"
	table_contents_name.text = updated_name_str
	table_contents_pg.text = updated_pg_str

func _on_button_pressed():
	index_pgs.visible = true
	index_pgs.show_pages("Inkit")

func _on_back_button_pressed():
	index_pgs.visible = false

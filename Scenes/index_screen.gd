extends Panel

@onready var contents_pg = $TableContents
@onready var table_contents_name = $TableContents/ToCNames
@onready var table_contents_pg = $TableContents/ToCPages
@onready var index_buttons = $TableContents/IndexTableButtons
@onready var index_pgs = $ArtlingIndexPg
@onready var next_pg_button = $NextButton
@onready var prev_pg_button = $PrevButton

var artling_tuples = [ ["Inkit", "Dewphin"], ["Wurm", "Bapig"], ["Hatguy", "Yolkcub"], ["Slicer", "Wurm Beast"] ]
@onready var artling_order = ["Inkit", "Dewphin", "Wurm", "Bapig", "Yolkcub", "Hatguy", "Slicer", "Wurm Beast"]
var artlings_discovered = ["Blank"]
var current_page = -1
var max_page = 3

func _ready():
	for i in index_buttons.get_child_count():
		var button = index_buttons.get_child(i)
		var callable = Callable(self, "_on_button_pressed").bind(i)
		button.connect("pressed", callable)
	"""var example_callable = Callable(self, "_on_button_pressed").bind(next_pg_button)
	next_pg_button.connect("pressed", example_callable)"""

func setup_index():
	index_pgs.visible = false
	current_page = -1
	prev_pg_button.disabled = true
	next_pg_button.disabled = false
	contents_pg.visible = true
	update_table_text()

func update_table_text():
	var updated_name_str = ""
	var updated_pg_str = ""
	for i in index_buttons.get_child_count():
		if i < len(artling_order):
			var artling = artling_order[i]
			if artling in artlings_discovered:
				updated_name_str += artling + "\n"
				updated_pg_str += str(i) + "\n"
			else:
				updated_name_str += "???"+ "\n"
				updated_pg_str += str(i) + "\n"
		else:
			index_buttons.get_child(i).visible = false
	table_contents_name.text = updated_name_str
	table_contents_pg.text = updated_pg_str

func show_page(index):
	contents_pg.visible = false
	index_pgs.visible = true
	var artling1 = artling_tuples[index]
	artling1 = artling1[0]
	var artling2 = artling_tuples[index]
	artling2 = artling2[1]
	if artling1 in artlings_discovered && artling2 in artlings_discovered:
		index_pgs.show_pages(artling1, artling2)
	elif artling1 in artlings_discovered:
		index_pgs.show_pages(artling1, "?")
	elif artling2 in artlings_discovered:
		index_pgs.show_pages("?", artling2)
	else:
		index_pgs.show_pages("?", "?")

func _on_button_pressed(index):
	index = floori(index/2)
	current_page = index
	show_page(index)
	if current_page == max_page:
		next_pg_button.disabled = true
		prev_pg_button.disabled = false
	else:
		prev_pg_button.disabled = false

func _on_back_button_pressed():
	index_pgs.visible = false

func _on_next_button_pressed():
	current_page += 1
	show_page(current_page)
	if prev_pg_button.disabled:
		prev_pg_button.disabled = false
	if current_page >= max_page:
		current_page = max_page
		next_pg_button.disabled = true

func _on_prev_button_pressed():
	current_page -= 1
	if current_page == -1:
		index_pgs.visible = false
		prev_pg_button.disabled = true
		contents_pg.visible = true
	else:
		show_page(current_page)
	
	if next_pg_button.disabled:
		next_pg_button.disabled = false

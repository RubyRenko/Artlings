extends Control

var artling_info = {
	"?" : ["???", preload("res://Assets/UI/QuestionMark.png"),\
	"Unknown artling", "Artist: ???", "Recipe: ???" ],
	"Inkit": ["Inkit", preload("res://Assets/artlings/InkStarterCropped.png"),\
	"A fox with an ink brush for a tail, specializes in applying blind", "Artist: Kevin Hong", "Recipe: 1 red, 1 blue, 1 yellow"],
	"Dewphin": ["Dewphin", preload("res://Assets/artlings/water_starter_paper.jpg"),\
	"A timid watercolor cetation who creates colorful healing bubbles", "Artist: Kevin Hong", "Recipe: 2+ blue, 1+ green"],
	"Wurm": ["Wurm", preload("res://Assets/artlings/wormCropped.png"),\
	"A sturdy teethy worm creature", "Artist: Aubrey Rhodes-Gorman", "Recipe: 3+ red"],
	"Bapig": ["Pabig", preload("res://Assets/artlings/Pig_arting.png"),\
	"A strong and fragile pig made of bacon", "Artist: Shiyu Li", "Recipe: 6 red"]
	}
@onready var page1 = $IndexPg1
@onready var page2 = $IndexPg2

func show_pages(artling1, artling2):
	var to_show1 = artling_info[artling1]
	var to_show2 = artling_info[artling2]
	
	page1.update_info(to_show1[0], to_show1[1], to_show1[2], to_show1[3], to_show1[4])
	page2.update_info(to_show2[0], to_show2[1], to_show2[2], to_show2[3], to_show2[4])

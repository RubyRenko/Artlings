extends Control

var artlings_order = ["Inkit", "Dewphin", "Wurm", "Bapig"]
var artling_info = {
	"Inkit": ["Inkit", preload("res://Assets/artlings/InkStarterCropped.png"),\
	"A fox with an ink brush for a tail, specializes in applying blind", "Drawn by: Kevin Hong", "Recipe: 1 red, 1 blue, 1 yellow"],
	"Dewphin": ["Dewphin", preload("res://Assets/artlings/water_starter_paper.jpg"),\
	"A timid watercolor cetation who creates colorful healing bubbles", "Drawn by: Kevin Hong", "Recipe: 2 blue, 1 green"]}
@onready var page1 = $IndexPg1
@onready var page2 = $IndexPg2

func show_pages(artling):
	var to_show1
	var to_show2
	if artling in artlings_order:
		var index = artlings_order.find(artling)
		if index % 2 == 0:
			to_show1 = artling_info[artling]
			to_show2 = artling_info[ artlings_order[index+1] ]
		else:
			to_show1 = artling_info[ artlings_order[index+-1] ]
			to_show2 = artling_info[artling]
	page1.update_info(to_show1[0], to_show1[1], to_show1[2], to_show1[3], to_show1[4])
	page2.update_info(to_show2[0], to_show2[1], to_show2[2], to_show2[3], to_show2[4])

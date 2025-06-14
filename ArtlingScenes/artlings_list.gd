extends Node
class_name ArtlingsMasterlist

var artlings_masterlist = {
	"Inkit": preload("res://ArtlingScenes/ink_starter.tscn"),
	"Dewphin": preload("res://ArtlingScenes/water_starter.tscn"),
	"Wurm": preload("res://ArtlingScenes/worm.tscn"),
	"Yolkcub": preload("res://ArtlingScenes/egg_bear.tscn"),
	"Bapig": preload("res://ArtlingScenes/bacon_pig.tscn"),
	"Hatguy": preload("res://ArtlingScenes/hatguy.tscn"),
	"Wurm Beast": preload("res://ArtlingScenes/wurm_beast.tscn"),
	"Slicer": preload("res://ArtlingScenes/slicer.tscn")
	}

func get_artling(artling):
	if artling in artlings_masterlist:
		return artlings_masterlist[artling]

func get_random_artling():
	return artlings_masterlist[artlings_masterlist.keys().pick_random()]

func get_random_artling_name():
	return artlings_masterlist.keys().pick_random()

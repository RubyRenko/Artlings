extends Node
class_name ArtlingsMasterlist

var artlings_masterlist = {
	"ink starter": preload("res://ArtlingScenes/ink_starter.tscn"),
	"water starter": preload("res://ArtlingScenes/water_starter.tscn"),
	"worm starter": preload("res://ArtlingScenes/worm.tscn"),
	"egg bear": preload("res://ArtlingScenes/egg_bear.tscn"),
	"bacon pig": preload("res://ArtlingScenes/bacon_pig.tscn")
	}

func get_artling(artling):
	if artling in artlings_masterlist:
		return artlings_masterlist[artling]

func get_random_artling():
	return artlings_masterlist[artlings_masterlist.keys().pick_random()]

func get_random_artling_name():
	return artlings_masterlist.keys().pick_random()

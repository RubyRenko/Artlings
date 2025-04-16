extends Node
class_name ArtlingsMasterlist

var artlings_masterlist = {
	"ink starter": preload("res://ArtlingScenes/ink_starter.tscn"),
	"water starter": preload("res://ArtlingScenes/water_starter.tscn"),
	"worm": preload("res://ArtlingScenes/worm.tscn"),
	"mon1": preload("res://ArtlingScenes/mon_1.tscn") #test mon
	}

func get_artling(artling):
	if artling in artlings_masterlist:
		return artlings_masterlist[artling]

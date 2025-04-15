extends Node

var master_artlings = {
	"worm": preload("res://ArtlingScenes/worm.tscn"),
	"mon1": preload("res://ArtlingScenes/mon_1.tscn")}

func get_artling(artling):
	return master_artlings[artling]

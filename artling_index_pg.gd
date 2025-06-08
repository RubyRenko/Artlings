extends Control

var artling_info = {
	#Unknown Artling
	"?" : ["???", preload("res://Assets/UI/QuestionMark.png"),\
	"Unknown artling", "Artist: ???", "Recipe: ???",\
	["???"] ],
	#Inkit
	"Inkit": ["Inkit", preload("res://Assets/artlings/Inkit_Party_Screen.png"),\
	"Tricksy and blinds anyone it doesn't like with it's precise brush strokes", "Artist: Kevin Hong", "Recipe: 1 red, 1 blue, 1 yellow",\
	["Brush", "Smoke", "Dollop", "InkSlash", "Stipple", "InkBlot"] ],
	#Dewphin
	"Dewphin": ["Dewphin", preload("res://Assets/artlings/Dewphy_Party_Screen_Export.png"),\
	"Timid and shy, spends it's time making colorful healing bubbles", "Artist: Kevin Hong", "Recipe: 2+ blue, 1+ green",\
	["Spout", "Bubble", "Rejuvinate", "Sap", "Wash", "Cure", "BubbleBurst"] ],
	#Wurm
	"Wurm": ["Wurm", preload("res://Assets/artlings/wormCropped.png"),\
	"While it has stubby little hands, it prefers to bite things", "Artist: Aubrey Rhodes-Gorman", "Recipe: 3+ red",\
	["Thud", "Charge", "Teeth", "Focus", "Blender", "Lick", "TeethShot"] ],
	#Bapig
	"Bapig": ["Bapig", preload("res://Assets/artlings/Pig_artingCropped.png"),\
	"Delivers devastating slaps of bacon for others and itself", "Artist: Shiyu Li", "Recipe: 6 red",\
	["Thud", "Charge", "BaconSlap", "Lick"] ],
	#Yolkcub
	"Yolkcub": ["Yolkcub", preload("res://Assets/artlings/EggbearCroppd.png"),\
	"An shy bear cub with sturdy egg protection", "Artist: Shiyu Li", "Recipe: 4+ yellow",\
	["Nibble", "Roll", "Focus", "Charge"] ],
	#Hatguy
	"Hatguy": ["Hatguy", preload("res://Assets/artlings/HatguyCropped.png"),\
	"Legs with a hat", "Artist: Lyssa (mzbljack)", "Recipe: 6 violet",\
	["Thud", "HatTip", "KarateKick"] ],
	#Laura's scissors
	"Slicer": ["Slicer", preload("res://Assets/artlings/tempsliceycropped.png"),\
	"Fragile and pinchy but great with crafts", "Artist: Zhou", "Recipe: 2+ red, 2+ violet",\
	["Thud", "HatTip", "KarateKick"] ],
	#Boss Wurm
	"Wurm Beast": ["Wurm Beast", preload("res://Assets/artlings/WurmEvo.png"),\
	"Now that it has hands with digits it has become too powerful", "Artist: Aubrey Rhodes-Gorman", "Recipe: ???",\
	["Teeth", "Blender", "TeethShot", "Screech", "Grapple"] ]
	}
@onready var page1 = $IndexPg1
@onready var page2 = $IndexPg2

func show_pages(artling1, artling2):
	if artling1 == "Blank" && artling2 == "Blank":
		page1.hide_info()
		page2.hide_info()
	elif artling1 == "Blank":
		page1.hide_info()
		var to_show2 = artling_info[artling2]
		page2.update_info(to_show2[0], to_show2[1], to_show2[2], to_show2[3], to_show2[4], to_show2[5])
	elif artling2 == "Blank":
		page2.hide_info()
		var to_show1 = artling_info[artling1]
		page1.update_info(to_show1[0], to_show1[1], to_show1[2], to_show1[3], to_show1[4], to_show1[5])
	else:
		var to_show1 = artling_info[artling1]
		page1.update_info(to_show1[0], to_show1[1], to_show1[2], to_show1[3], to_show1[4], to_show1[5])
		var to_show2 = artling_info[artling2]
		page2.update_info(to_show2[0], to_show2[1], to_show2[2], to_show2[3], to_show2[4], to_show2[5])

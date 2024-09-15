extends Node

#Catalonia = 0,...
var scenario : int = 0

@onready var main = $"../"

var data = {
	0 : {
		0 : {
			"name" : "Vandellòs",
			"position" : Vector2(704,3264),
			"type" : "nc"
		},
		1 : {
			"name" : "Ascó",
			"position" : Vector2(704, 2752),
			"type" : "nc"
		},
		2 : {
			"name" : "Terra dels serrats",
			"position" : Vector2(1216, 2368),
			"type" : "wt"
		},
		3 : {
			"name" : "Les Colladetes",
			"position" : Vector2(448, 3520),
			"type" : "wt"
		},
		4 : {
			"name" : "Trucafort",
			"position" : Vector2(832, 3008),
			"type" : "wt"
		},
		5 : {
			"name" : "Barcelona I",
			"position" : Vector2(1600,3008),
			"type" : "cp"
		},
		6 : {
			"name" : "Barcelona II",
			"position" : Vector2(1472,2880),
			"type" : "cp"
		},
		7 : {
			"name" : "Barcelona III",
			"position" : Vector2(2496,2624),
			"type" : "cp"
		},
		8 : {
			"name" : "Barcelona IV",
			"position" : Vector2(2368,2496),
			"type" : "cp"
		},
		9 : {
			"name" : "Barcelona V",
			"position" : Vector2(2240,2496),
			"type" : "cp"
		},
		10 : {
			"name" : "Tarragona I",
			"position" : Vector2(2240,2880),
			"type" : "cp"
		},
		11 : {
			"name" : "Tarragona II",
			"position" : Vector2(2112,2880),
			"type" : "cp"
		}
	}
}

# Called when the node enters the scene tree for the first time.
func begin_load() -> void:
	for num in data[scenario]:
		$"../".place_building(data[scenario][num]["position"], data[scenario][num]["type"], false)

func get_upkeep():
	var upkeep = 0
	for building in main.buildings_created:
		if building.upkeep != null:
			upkeep += building.upkeep
		else:
			print("!!!!!!!!!Error!!!!!!!!!! Getting building: ",  building, " upkeep.")
	
	return upkeep

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

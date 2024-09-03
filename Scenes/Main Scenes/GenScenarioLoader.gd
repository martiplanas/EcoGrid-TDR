extends Node

#Catalonia = 0,...
var scenario : int = 0

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
		}
	}
}

# Called when the node enters the scene tree for the first time.
func begin_load() -> void:
	for num in data[scenario]:
		$"../".place_building(data[scenario][num]["position"], data[scenario][num]["type"], false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

extends Node

var scenario_data = {}

var cityScene = preload("res://Scenes/Buildings/City.tscn")
@onready var cityContainer = get_node("../TileMap/Cities")

var citynames = ["Girona", "Barcelona", "Lleida", "Tarragona", "Manresa"]
var citypos = [Vector2(3264, 1600), Vector2(2368,2752), Vector2(320,2112), Vector2(1344,3008), Vector2(1856,1984)]
# Called when the node enters the scene tree for the first time.
func _ready():
	var i = 0
	for city in citynames:
		var newCity = cityScene.instantiate()
		newCity.position
		cityContainer.add_child(newCity)
		newCity.position = citypos[i]
		i += 1
	
	cityContainer.loadCities()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

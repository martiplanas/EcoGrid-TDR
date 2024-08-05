extends Node

var scenario_data = {}

var cityScene = preload("res://Scenes/Buildings/City.tscn")
@onready var cityContainer = get_node("../TileMap/Cities")

var cities = {
	"Girona": {"position": Vector2(3264, 1600), "population": 100000, "l1": 500, "l2" : 1000, "l3" : 2000 , "l4" : 5000, "l5" : 10000 , "unlock_order" : 1, "description": "res://Recources/Critique/cities/Girona.txt"},
	"Barcelona": {"position": Vector2(2368, 2752), "population": 1600000, "l1": 2000, "l2" : 10000, "l3" : 50000 , "l4" : 100000, "l5" : 600000, "unlock_order" : 4, "description": "res://Recources/Critique/cities/Barcelona.txt"},
	"Lleida": {"position": Vector2(320, 2112), "population": 138000, "l1": 1000, "l2" : 2000, "l3" : 5000 , "l4" : 7500, "l5" : 20000, "unlock_order" : 3, "description": "res://Recources/Critique/cities/Lleida.txt"},
	"Tarragona": {"position": Vector2(1344, 3008), "population": 134000, "l1": 750, "l2" : 1000, "l3" : 2000 , "l4" : 5000, "l5" : 20000, "unlock_order" : 2, "description": "res://Recources/Critique/cities/Tarragona.txt"},
	"Manresa": {"position": Vector2(1856, 1984), "population": 76000, "l1": 200, "l2" : 500, "l3" : 1000 , "l4" : 2500, "l5" : 5000, "unlock_order" : 0, "description": "res://Recources/Critique/cities/Manresa.txt"}
}

var buildings = {
	"wt" : 100,
	"sp" : 200,
	"nc" : 2000
}

#Legacy city data
var citynames = ["Girona", "Barcelona", "Lleida", "Tarragona", "Manresa"]
var citypos = [Vector2(3264, 1600), Vector2(2368,2752), Vector2(320,2112), Vector2(1344,3008), Vector2(1856,1984)]

# Called when the node enters the scene tree for the first time.
func _ready():
	load_cities()

func load_cities():
	for city_name in cities.keys():
		var newCity = cityScene.instantiate()
		newCity.position = cities[city_name]["position"]
		newCity.name = city_name
		cityContainer.add_child(newCity)
		#if cities[city_name]["unlock_order"] == 0:
		newCity.visible = true
		#else:
			#newCity.visible = false
			#newCity.set_process(false)
		
		#Add levels
		newCity.needs.append(cities[city_name]["l1"])
		newCity.needs.append(cities[city_name]["l2"])
		newCity.needs.append(cities[city_name]["l3"])
		newCity.needs.append(cities[city_name]["l4"])
		newCity.needs.append(cities[city_name]["l5"])
		
	cityContainer.loadCities()
	SimulationManager.begin_simulation()

extends Node

var scenario_data = {}

var cityScene = preload("res://Scenes/Buildings/City.tscn")
@onready var cityContainer = get_node("../TileMap/Cities")
@onready var generatorControler = get_node("../Generators")
@onready var time_manager = get_node("../TimerJesus")
@onready var ui = get_node("../Camera2D/UI")

var cities = {
	"Girona": {"position": Vector2(3264, 1600), "population": 100000, "l1": 1000, "l2" : 2500, "l3" : 5000 , "l4" : 12000, "l5" : 25000 , "unlock_order" : 1, "description": "res://Recources/Critique/cities/Girona.txt"},
	"Barcelona": {"position": Vector2(2368, 2752), "population": 1600000, "l1": 5000, "l2" : 10000, "l3" : 25000 , "l4" : 50000, "l5" : 150000, "unlock_order" : 4, "description": "res://Recources/Critique/cities/Barcelona.txt"},
	"Lleida": {"position": Vector2(320, 2112), "population": 138000, "l1": 1500, "l2" : 3500, "l3" : 10000 , "l4" : 20000, "l5" : 30000, "unlock_order" : 3, "description": "res://Recources/Critique/cities/Lleida.txt"},
	"Tarragona": {"position": Vector2(1344, 3008), "population": 134000, "l1": 1000, "l2" : 3000, "l3" : 7000 , "l4" : 10000, "l5" : 20000, "unlock_order" : 2, "description": "res://Recources/Critique/cities/Tarragona.txt"},
	"Manresa": {"position": Vector2(1856, 1984), "population": 76000, "l1": 500, "l2" : 1500, "l3" : 2500 , "l4" : 5000, "l5" : 10000, "unlock_order" : 0, "description": "res://Recources/Critique/cities/Manresa.txt"}
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

func _on_load_scenario_retarder_timeout() -> void:
	if SimulationManager.historyMode:
		generatorControler.begin_load()
		time_manager.pause_game()
		
		ui.begin_history_mode()

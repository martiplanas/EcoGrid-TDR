extends Node

var scenario_data = {}
# Called when the node enters the scene tree for the first time.
func _ready():
	load_scenario_data("res://Recources/scenarios.tres")
	load_scenario("CAT")

func load_scenario_data(file_path: String):
	var file = FileAccess.open(file_path, FileAccess.READ)
	if not file:
		print("Error: Unable to open file at %s" % file_path)
		return
	var json_as_text = file.get_as_text()
	print(json_as_text)
	scenario_data = JSON.parse_string(json_as_text)
	
	print(scenario_data)

func load_scenario(scenario_name: String):
	print("A")
	if not scenario_data.has(scenario_name):
		print("Scenario not found: %s" % scenario_name)
		return
		
	var scenario = scenario_data[scenario_name]
	for city_info in scenario.cities:
		add_city(city_info.ID, city_info.cityname, Vector2(city_info.position[0], city_info.position[1]), city_info.energy_consumption)

func add_city(ID: String, cityname: String, position: Vector2, energy_consumption: float):
	var city_scene = preload("res://Scenes/City.tscn")
	var city = city_scene.instance()
	city.ID = ID
	city.cityname = cityname
	city.position = position
	city.energy_consumption = energy_consumption
	get_node("Map/CitiesContainer").add_child(city)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

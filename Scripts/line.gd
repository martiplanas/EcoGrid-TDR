extends Line2D

var previous_ammonut_points
var city_deliver
var times = 0
var exist = false

var energy_generation

var generators = []
@onready var city_controler = $"../../TileMap/Cities"
@onready var money = $"../../Camera2D/UI/MoneyDisplay"
@onready var main = $"../../"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	update_stats()
	
	if self.get_point_count() <= 0:
		exist = false
	elif exist == false:
		exist = true
		initzialitzate_line()
	
	if exist:
		self.visible = true
	else:
		self.visible = false
	
	if previous_ammonut_points != self.get_point_count():
		previous_ammonut_points = self.get_point_count()
		update_stats()
	

func update_stats():
	generators.clear()
	
	for building in main.buildings_created:
		for point in range(self.get_point_count()):
			if building.position == self.get_point_position(point):
				generators.append(building)
	
	energy_generation = 0
	for generator in generators:
		energy_generation += generator.get_meta("Energy_Production")

func initzialitzate_line():
	previous_ammonut_points = self.get_point_count()
	#GET LINE CITY
	for city in city_controler.cities:
		for point in range(self.get_point_count()):
			if city.position == self.get_point_position(point):
				city_deliver = city

	city_deliver.lines.append(self)



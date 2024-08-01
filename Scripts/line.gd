extends Line2D

var previous_ammonut_points
var city_deliver
var times = 0
var exist = false

var line_generating:float = 0 
var delivery_ammount:float = 0
var delivery_percent:float = 0

var previous_generating:float = 0

var generators = []
@onready var city_controler = $"../../TileMap/Cities"
@onready var money = $"../../Camera2D/UI/MoneyDisplay"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.get_point_count() <= 0:
		exist = false
	elif exist == false:
		exist = true
		initzialitzate_line()
	
	if previous_ammonut_points != self.get_point_count():
		previous_ammonut_points = self.get_point_count()
		update_stats()

func update_stats():
	generators.clear()
	
	for building in SimulationManager.buildings:
		for point in range(self.get_point_count()):
			if building.position == self.get_point_position(point):
				generators.append(building)
	
	line_generating = 0
	for building in generators:
		line_generating += building.get_meta("Energy_Production")
	
	if previous_generating != line_generating:
		var percent_change 
		if not city_deliver == null:
			if not delivery_ammount == 0:
				percent_change = ((line_generating - previous_generating)/delivery_ammount)*100
				delivery_percent = (line_generating / delivery_ammount)* 100
			else:
				delivery_percent = 0
			previous_generating = line_generating
			city_deliver.set_deliver(percent_change)

func initzialitzate_line():
	previous_ammonut_points = self.get_point_count()
	#GET LINE CITY
	for city in city_controler.cities:
		for point in range(self.get_point_count()):
			if city.position == self.get_point_position(point):
				city_deliver = city
	
	delivery_ammount = SimulationManager.citydata[city_deliver]["base_needs"]

func hour_money_get():
	var energy_delivered:int = 0
	for generator in generators:
		energy_delivered += generator.get_meta("Energy_Production")
	
	if energy_delivered != 0 or energy_delivered != null:
		if energy_delivered < delivery_ammount:
			money.modify_money(energy_delivered)
		elif energy_delivered >= delivery_ammount:
			money.modify_money(delivery_ammount)

extends Line2D

var previous_ammonut_points
var city_deliver
var times = 0
var exist = false
@onready var city_controler = $"../../TileMap/Cities"

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
	times += 1

func initzialitzate_line():
	previous_ammonut_points = self.get_point_count()
	#GET LINE CITY
	for city in city_controler.cities:
		for point in range(self.get_point_count()):
			if city.position == self.get_point_position(point):
				city_deliver = city
	
	

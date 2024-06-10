extends StaticBody2D

# Variables for resource generation
var electricity_output = 10
var connected = false

func _ready():
	# Initialize the building (e.g., set up animations, etc.)
	pass

func place_building(position):
	self.position = position
	# Additional logic for placing the building
	connect_to_city()

func connect_to_city():
	# Logic for connecting the building to the nearest city
	# This is a placeholder function; you will need to implement the actual logic
	connected = true
	print("Building connected to city.")

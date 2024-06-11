extends Node2D

# Reference to the building scene
var WindTurbineScene = preload("res://Scenes/Placeholders/wind_turbine.tscn")

const GRID_SIZE = 32  # Adjust this value to your grid size

func _ready():
	set_process_input(true)

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			place_building(event.position)

func place_building(position):
	var new_building = WindTurbineScene.instantiate()
	print("Building created on", str(position))
	add_child(new_building)
	new_building.position = snap_to_grid(position)

func snap_to_grid(position):
	# Calculate the nearest grid point
	position.x = round(position.x / GRID_SIZE) * GRID_SIZE
	position.y = round(position.y / GRID_SIZE) * GRID_SIZE
	return position

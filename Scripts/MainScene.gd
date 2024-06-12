extends Node2D

# Reference to the building scene
var WindTurbineScene = preload("res://Scenes/Placeholders/wind_turbine.tscn")

const GRID_SIZE = 32  # Adjust this value to your grid size

var occupied_positions = {}

#---Buildings Avalible---
var wt_avalible = 0
var sp_avalible = 0
var nc_avalible = 0

#0=nobuilding/1=wt/2=sp/3=nc
var buildingSelected = 0

func _ready():
	set_process_input(true)

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			place_building(event.position)

func place_building(position):
	if buildingSelected != 0:
		var grid_position = snap_to_grid(position)
		if grid_position not in occupied_positions && !is_mouse_over_ui():
			if buildingSelected == 1:
				if wt_avalible >= 1:
					var new_building = WindTurbineScene.instantiate()
					wt_avalible -= 1
					print("Building created on", str(position))
					add_child(new_building)
					new_building.position = grid_position
					occupied_positions[grid_position] = new_building
		else:
			print("Place ocupied")

func snap_to_grid(position):
	# Calculate the nearest grid point
	position.x = round(position.x / GRID_SIZE) * GRID_SIZE
	position.y = round(position.y / GRID_SIZE) * GRID_SIZE
	return position

func _on_mousemode_pressed():
	buildingSelected = 0
	print("Building Selected: ", buildingSelected)

func _on_wind_turbine_build_pressed():
	buildingSelected = 1
	print("Building Selected: ", buildingSelected)

func _on_solar_panel_build_pressed():
	buildingSelected = 0
	#print("Building Selected: ", buildingSelected)
	wt_avalible += 1

func is_mouse_over_ui():
	var ui_elements = get_tree().get_nodes_in_group("ui")
	for element in ui_elements:
		if element is Button and element.get_rect().has_point(element.get_global_mouse_position()):
			return true
	return false

extends Node2D

# Reference to the building scene
var WindTurbineScene = preload("res://Scenes/Placeholders/wind_turbine.tscn")
var SolarPanelScene = preload("res://Scenes/Placeholders/solar_panel.tscn")
var NuclearPlantScene = preload("res://Scenes/Placeholders/nuclear_plant.tscn")

const GRID_SIZE = 64  # Adjust this value to your grid size

var occupied_positions = {}

#---Buildings Avalible---
var wt_avalible = 1
var sp_avalible = 3
var nc_avalible = 10

#0=nobuilding/1=wt/2=sp/3=nc
var button_selected = 0
var buildmode = false
@onready var ui_manager = get_node("Camera2D/Control")

func _ready():
	set_process_input(true)

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if buildmode:
				place_building(event.position)

func _process(delta):
	button_selected = ui_manager.current_button_selected
	
	if button_selected == 1 or button_selected == 2 or button_selected == 3:
		buildmode = true
	else:
		buildmode = false

func place_building(position):
	var grid_position = snap_to_grid(position)
	if grid_position not in occupied_positions && !is_mouse_over_ui():
		if button_selected == 1:
			if wt_avalible >= 1:
				var new_building = WindTurbineScene.instantiate()
				wt_avalible -= 1
				print("Building created on", str(position))
				add_child(new_building)
				new_building.position = grid_position
				occupied_positions[grid_position] = new_building
			else:
				print("You don't have enough buildings of this type")
		elif button_selected == 2:
			if sp_avalible >= 1:
				var new_building = SolarPanelScene.instantiate()
				sp_avalible -= 1
				print("Building created on", str(position))
				add_child(new_building)
				new_building.position = grid_position
				occupied_positions[grid_position] = new_building
			else:
				print("You don't have enough buildings of this type")
		elif button_selected == 3:
			if nc_avalible >= 1:
				var new_building = NuclearPlantScene.instantiate()
				nc_avalible -= 1
				print("Building created on", str(position))
				add_child(new_building)
				new_building.position = grid_position
				occupied_positions[grid_position] = new_building
			else:
				print("You don't have enough buildings of this type")

func snap_to_grid(position):
	# Calculate the nearest grid point
	position.x = round(position.x / GRID_SIZE) * GRID_SIZE
	position.y = round(position.y / GRID_SIZE) * GRID_SIZE
	return position

func is_mouse_over_ui():
	var ui_elements = get_tree().get_nodes_in_group("ui")
	for element in ui_elements:
		if element is Button and element.get_rect().has_point(element.get_global_mouse_position()):
			return true
	return false

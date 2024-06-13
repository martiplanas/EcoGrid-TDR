extends Node2D

# Reference to the building scene
var WindTurbineScene = preload("res://Scenes/Placeholders/wind_turbine.tscn")
var SolarPanelScene = preload("res://Scenes/Placeholders/solar_panel.tscn")
var NuclearPlantScene = preload("res://Scenes/Placeholders/nuclear_plant.tscn")

const GRID_SIZE = 64  # Adjust this value to your grid size

var occupied_positions = {}
var buildings_created = []

#---Buildings Avalible---
var wt_avalible = 10
var sp_avalible = 10
var nc_avalible = 10

var is_mouse_over_ui = false

#0=nobuilding/1=wt/2=sp/3=nc
var button_selected = 0
var buildmode = false
var demolishmode = false
@onready var ui_manager = get_node("Camera2D/Control")
@onready var tilemap = $TileMap  # Ensure you have a TileMap node in your scene

func _ready():
	set_process_input(true)

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if buildmode:
				var mouse_pos = get_global_mouse_position()
				place_building(mouse_pos)
			if demolishmode:
				var mouse_pos = snap_to_grid(get_global_mouse_position())
				for i in buildings_created:
					var building_pos = i.position
					if mouse_pos == building_pos:
						if i.get_meta("Type") == "wt":
							wt_avalible += 1
						elif i.get_meta("Type") == "sp":
							sp_avalible += 1
						elif i.get_meta("Type") == "nc":
							nc_avalible += 1
						
						occupied_positions.erase(building_pos)
						i.queue_free()
						buildings_created.erase(i)

func _process(delta):
	button_selected = ui_manager.current_button_selected
	
	if button_selected == 1 or button_selected == 2 or button_selected == 3:
		buildmode = true
	else:
		buildmode = false
	
	if button_selected == 5:
		demolishmode = true
	else:
		demolishmode = false

func place_building(position):
	var grid_position = snap_to_grid(position)
	if grid_position not in occupied_positions and !is_mouse_over_ui:
		if button_selected == 1:
			if wt_avalible >= 1:
				var new_building = WindTurbineScene.instantiate()
				wt_avalible -= 1
				print("Building created on", str(position))
				buildings_created.append(new_building)
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
				buildings_created.append(new_building)
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
				buildings_created.append(new_building)
				occupied_positions[grid_position] = new_building
			else:
				print("You don't have enough buildings of this type")

func snap_to_grid(position: Vector2) -> Vector2:
	var map_coords = tilemap.local_to_map(position)
	var tile_center = tilemap.map_to_local(map_coords)
	return tile_center

func _on_panel_container_mouse_entered():
	is_mouse_over_ui = true
func _on_panel_container_mouse_exited():
	is_mouse_over_ui = false
func _on_mouse_mode_mouse_exited():
	is_mouse_over_ui = false
func _on_building_wt_mouse_exited():
	is_mouse_over_ui = false
func _on_building_wt_mouse_entered():
	is_mouse_over_ui = true
func _on_mouse_mode_mouse_entered():
	is_mouse_over_ui = true
func _on_building_sp_mouse_entered():
	is_mouse_over_ui = true
func _on_building_sp_mouse_exited():
	is_mouse_over_ui = false
func _on_building_nc_mouse_exited():
	is_mouse_over_ui = false
func _on_building_nc_mouse_entered():
	is_mouse_over_ui = true
func _on_line_creator_mouse_exited():
	is_mouse_over_ui = false
func _on_line_creator_mouse_entered():
	is_mouse_over_ui = true
func _on_demolisher_mouse_entered():
	is_mouse_over_ui = true
func _on_demolisher_mouse_exited():
	is_mouse_over_ui = false

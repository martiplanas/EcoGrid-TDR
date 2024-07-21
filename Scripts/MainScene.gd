extends Node2D

@onready var line_manager = $Lines

const GRID_SIZE = 128  # Adjust this value to your grid size

var occupied_positions = {}
var buildings_created = []

#---Buildings Arrays---
@onready var building_buttons = {
	"wt" : $Camera2D/UI/PanelContainer/VBoxContainer2/Building_wt, 
	"sp" : $Camera2D/UI/PanelContainer/VBoxContainer2/Building_sp, 
	"nc" : $Camera2D/UI/PanelContainer/VBoxContainer2/Building_nc
}
	
var buildings_avalible = {"wt": 2,"sp": 2,"nc": 0}
var button_to_id = {1 : "wt", 2 : "sp", 3 : "nc"}
var buildings_scenes = {"wt" : preload("res://Scenes/Buildings/wind_turbine.tscn"), "sp" : preload("res://Scenes/Buildings/solar_panel.tscn"), "nc" : ("res://Scenes/Buildings/nuclear_plant.tscn")}

var is_mouse_over_ui = false

#0=nobuilding/1=wt/2=sp/3=nc
var button_selected = 0
var buildmode = false
var demolishmode = false
@onready var ui_manager = get_node("Camera2D/UI")
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
						demolish_building(i, building_pos)

func demolish_building(building, building_pos):
	modify_avalibe(building, +1)
	occupied_positions.erase(building_pos)
	building.queue_free()
	buildings_created.erase(building)
	
	for line in line_manager.lines:
		for i in range(line.get_point_count()):
			if line.get_point_position(i) == building_pos:
				line.remove_point(i)

func modify_avalibe(building, count):
	print(building.get_meta("Typed"))
	buildings_avalible[building.get_meta("Type")] += count

func _process(delta):
	button_selected = ui_manager.current_button_selected
	
	# Set buildmode based on button_selected
	buildmode = button_selected in [1, 2, 3]
	# Set demolishmode based on button_selected
	demolishmode = (button_selected == 5)
	
	disable_no_disponibles()

func place_building(position):
	var grid_position = snap_to_grid(position)
	if grid_position not in occupied_positions and !is_mouse_over_ui:
		var building_id = button_to_id[button_selected]
		print(building_id)
		print(buildings_avalible[building_id])
		
		if buildings_avalible[building_id] >= 1:
			var new_building = buildings_scenes[building_id].instantiate()
			buildings_created.append(new_building)
			add_child(new_building)
			new_building.position = grid_position
			occupied_positions[grid_position] = new_building
			print("New building ", new_building, " created on ", str(grid_position) ,".")
			modify_avalibe(new_building, -1)
		else:
			print("Not enough buildings of this type.")
	else:
		print("position ocupied")

func snap_to_grid(positions: Vector2) -> Vector2:
	var map_coords = tilemap.local_to_map(positions)
	
	var tile_center = tilemap.map_to_local(map_coords)
	return tile_center

func disable_no_disponibles():
	for key in buildings_avalible.keys():
		if buildings_avalible[key] == 0:
			building_buttons[key].disabled = true
		else:
			building_buttons[key].disabled = false

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

extends Node2D

@onready var line_manager = $Lines
@onready var ui = $Camera2D/UI
@onready var scnl = $ScenarioLoader
@onready var money = $Camera2D/UI/MoneyDisplay

const GRID_SIZE = 128  # Adjust this value to your grid size

var occupied_positions = {}
var buildings_created = []
var buildable_tiles = []

#---Buildings Arrays---
@onready var building_buttons = {
	"wt" : $Camera2D/UI/ToolBar/VBoxContainer/Building_wt, 
	"sp" : $Camera2D/UI/ToolBar/VBoxContainer/Building_sp, 
	"nc" : $Camera2D/UI/ToolBar/VBoxContainer/Building_nc
}

var description_locations = {"wt": "res://Recources/Critique/Wind.txt", "sp": "res://Recources/Critique/Solar.txt", "nc": "res://Recources/Critique/Nuclear.txt"}

var color_modifier = {0 : 0.25, 1 : 0.5, 2 : 0.75, 3 : 1.25, 4 : 1.75}
var building_type_layer = {"wt":6, "sp":8, "nc":0}

var building_price = {"wt": 800, "sp": 1000, "nc": 50000}
var buildings_avalible = {"wt": 1,"sp": 1,"nc": 1}
var button_to_id = {1 : "wt", 2 : "sp", 3 : "nc"}
var id_to_L_name = {"wt": "Wind Turbine", "sp": "Solar panels", "nc": "Nuclear Power Plant"}
var buildings_scenes = {"wt" : preload("res://Scenes/Buildings/wind_turbine.tscn"), "sp" : preload("res://Scenes/Buildings/solar_panel.tscn"), "nc" : preload("res://Scenes/Buildings/nuclear_plant.tscn")}
var build_models_scenes = {"wt": preload("res://Scenes/Buildings/wind_turbine_build_mode.tscn"), "sp":preload("res://Scenes/Buildings/solar_panel_build_mode.tscn"), "nc" : preload("res://Scenes/Buildings/nuclear_plant_build_mode.tscn")}

var infoPanel = preload("res://Scenes/UI/infoPanel.tscn")

var is_mouse_over_ui = false

#0=nobuilding/1=wt/2=sp/3=nc
var button_selected = 0
var buildmode = false
var demolishmode = false

var current_build_model
var current_build_type

@onready var ui_manager = get_node("Camera2D/UI")
@onready var tilemap = $TileMap  # Ensure you have a TileMap node in your scene

func _ready():
	var buildable_tiles_i = $TileMap.get_used_cells(9)
	for tile in buildable_tiles_i:
		if tilemap.get_cell_source_id(9, tile) != 3:
			buildable_tiles.append(Vector2((tile.x*128)+64,(tile.y*128)+64))
	
	set_process_input(true)

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if button_selected == 0:
				check_for_info(snap_to_grid(get_global_mouse_position()))
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
	occupied_positions.erase(building_pos)
	building.queue_free()
	buildings_created.erase(building)
	
	for line in line_manager.lines:
		for i in range(line.get_point_count()):
			if line.get_point_position(i) == building_pos:
				line.remove_point(i)

func check_for_info(position):
	if not is_mouse_over_ui:
		for building in buildings_created:
			if building.position == position:
				var key = building.get_meta("Type")
				
				var newPanel = infoPanel.instantiate()
				ui.add_child(newPanel)
				
				var title = id_to_L_name[key] + " info"
				var description = load_text_file(description_locations[key])
				var generating_num = "Energy generation: " + str(building.get_meta("Energy_Production"))
				
				newPanel.set_texts(title, description, generating_num, "", "")
		for city in $TileMap/Cities.cities:
			if city.position == position and city.is_visible_in_tree():
				var newPanel = infoPanel.instantiate()
				ui.add_child(newPanel)
				
				var title = city.name + " info"
				var description = load_text_file(scnl.cities[city.name]["description"])
				var info1 = "Energy needs: " + str(city.current_needs)
				var info2 = "Population: " + str(scnl.cities[city.name]["population"])
				var info3 = "Level: " + str(city.level) + "/5"
				
				newPanel.set_texts(title, description, info1, info2, "")

func _process(_delta):
	button_selected = ui_manager.current_button_selected
	
	SimulationManager.buildings = buildings_created
	# Set buildmode based on button_selected
	buildmode = button_selected in [1, 2, 3]
	# Set demolishmode based on button_selected
	demolishmode = (button_selected == 5)
	
	if buildmode:
		var id = button_to_id[button_selected]
		if current_build_type != id:
			current_build_type = id
			if current_build_model != null:
				current_build_model.queue_free()
			current_build_model = build_models_scenes[id].instantiate()
			add_child(current_build_model)
		elif current_build_type == id:
			if current_build_model != null:
				current_build_model.position = snap_to_grid(get_global_mouse_position())
				
				var price_tag
				var energy_tag
				var position_tag
				
				var price_can = false
				var position_can = false
				
				for childs in current_build_model.get_child(1).get_child(0).get_children():
					if childs.name ==  "price":
						price_tag = childs
					if childs.name == "position":
						position_tag = childs
					if childs.name == "energy":
						energy_tag = childs
				
				if price_tag != null:
					if money.is_enough_money(building_price[id]):
						price_tag.text = "Price: " + str(building_price[id])
						price_tag.modulate = Color(0.5,255,0.5,1)
						price_can = true
					else:
						price_can = false
						price_tag.text = "Not enough money, price: " + str(building_price[id])
						price_tag.modulate = Color(1,0.25,0.25,1)
				
				if position_tag != null:
					var grid_position = snap_to_grid(get_global_mouse_position())
					if grid_position not in occupied_positions and grid_position in buildable_tiles:
						position_tag.text = "This position is avalible."
						position_tag.modulate = Color(0.5,1,0.5,1)
						position_can = true
					else:
						position_tag.text = "This position is not buildable."
						position_tag.modulate = Color(1,0.25,0.25,1)
						position_can = false
				
				if energy_tag != null and position_can:
					var grid_position = snap_to_grid(get_global_mouse_position())
					var layer_num = building_type_layer[id]
					var modifier = get_position_modifier(layer_num, grid_position)
					var building_base_production = scnl.buildings[id]
					var final_production = modifier * building_base_production
					energy_tag.text = "Energy production at this position: " + str(final_production) + "."
				else:
					energy_tag.text = "Energy production at this position: 0"
				
				if price_can == false or position_can == false:
					current_build_model.get_child(0).modulate = Color(1,0.25,0.25,0.75)
				else:
					current_build_model.get_child(0).modulate = Color(0.5,1,0.5,0.75)
				
				if is_mouse_over_ui:
					current_build_model.visible = false
				else:
					current_build_model.visible = true
	else:
		if current_build_model != null:
			current_build_model.queue_free()
			current_build_model = null
			current_build_type = null
	
	disable_no_disponibles()

func place_building(position):
	var grid_position = snap_to_grid(position)
	if grid_position not in occupied_positions and !is_mouse_over_ui and grid_position in buildable_tiles:
		var building_id = button_to_id[button_selected]
		if money.is_enough_money(building_price[building_id]):
			if buildings_avalible[building_id] >= 1:
				money.modify_money(-building_price[building_id])
				var new_building = buildings_scenes[building_id].instantiate()
				buildings_created.append(new_building)
				add_child(new_building)
				new_building.position = grid_position
				
				#Get modifier
				var layer = building_type_layer[building_id]
				new_building.output_modifier = get_position_modifier(layer, grid_position)
				
				occupied_positions[grid_position] = new_building
				print("New building ", new_building, " created on ", str(grid_position) ,".")
			else:
				print("Not enough buildings of this type.")
		else:
			print("You dont have money")
	else:
		print("position ocupied")

func snap_to_grid(positions: Vector2) -> Vector2:
	var map_coords = tilemap.local_to_map(positions)
	
	var tile_center = tilemap.map_to_local(map_coords)
	return tile_center

func disable_no_disponibles():
	for key in buildings_avalible.keys():
		if buildings_avalible[key] == 0:
			building_buttons[key].visible = false
		else:
			building_buttons[key].visible = true

func load_text_file(path: String) -> String:
	var file = FileAccess.open(path, FileAccess.READ)
	var content = file.get_as_text()
	return content

func get_position_modifier(layer, position):
	if layer != 0:
		var position_atlas:Vector2i = Vector2i((position.x-64)/128,(position.y-64)/128)
		var color_grade = tilemap.get_cell_atlas_coords(layer, position_atlas).x
		return color_modifier[color_grade]
	else:
		return 1

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

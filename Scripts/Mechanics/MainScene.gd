extends Node2D

@onready var line_manager = $Lines
@onready var ui = $Camera2D/UI
@onready var scnl = $ScenarioLoader
@onready var money = $Camera2D/UI/MoneyDisplay
@onready var building_container = $Generators
@onready var hover = $HoverC
@onready var citymanager = $TileMap/Cities

const GRID_SIZE = 128

var occupied_positions = {}
var buildings_created = []
var buildable_tiles = []
var hoverable_items = []

var forest_tiles = []
var river_tiles = []
var seaA_tiles = []
var seaB_tiles = []
var seaC_tiles = []

#---Buildings Arrays---
@onready var building_data = {
	"wt" : {
		"name" : "Wind Turbine",
		"description" : "res://Recources/Buildings/Wind Turbine/Wind.txt",
		"scene" : preload("res://Recources/Buildings/Wind Turbine/wind_turbine.tscn"),
		"cursor" : preload("res://Recources/Buildings/Wind Turbine/wind_turbine_cursor.tscn"),
		"price" : 1000,
		"generation" : 180, 
		"pollution" : 0,
		"upkeep" : 120,
		"unlocked" : true,
		"layer" : 8
	},
	"sp" : {
		"name" : "Solar Panels",
		"description" : "res://Recources/Buildings/Solar Panels/Solar.txt",
		"scene" : preload("res://Recources/Buildings/Solar Panels/solar-panel-2.tscn"),
		"cursor" : preload("res://Recources/Buildings/Solar Panels/solar_panel_cursor.tscn"),
		"price" : 1500,
		"generation" : 250,
		"pollution" : 0,
		"upkeep" : 90,
		"unlocked" : true,
		"layer" : 10
	},
	"nc" : {
		"name" : "Nuclear Power Plant",
		"description" : "res://Recources/Buildings/Nuclear Power Plant/Nuclear.txt",
		"scene" : preload("res://Recources/Buildings/Nuclear Power Plant/nuclear_plant.tscn"),
		"cursor" : preload("res://Recources/Buildings/Nuclear Power Plant/nuclear_plant_cursor.tscn"),
		"price" : 200000,
		"generation" : 4000,
		"pollution" : 0.05,
		"upkeep" : 2000,
		"unlocked" : true,
		"layer" : 0
	},
	"gt" : {
		"name" : "Geothermal Power Plant",
		"description" : "res://Recources/Buildings/Geotermical/Geo.txt",
		"scene" : preload("res://Recources/Buildings/Geotermical/Geothermal.tscn"),
		"cursor" : preload("res://Recources/Buildings/Geotermical/Geothermal_cursor.tscn"),
		"price" : 10000,
		"generation" : 600,
		"pollution" : 0,
		"upkeep" : 300,
		"unlocked" : true,
		"layer" : 9
	},
	"hp" : {
		"name" : "Hydropower",
		"description" : "res://Recources/Buildings/Hydropower/Hydro.txt",
		"scene" : preload("res://Recources/Buildings/Hydropower/Hydropower.tscn"),
		"cursor" : preload("res://Recources/Buildings/Hydropower/Hydropower_cursor.tscn"),
		"price" : 50000,
		"generation" : 5500,
		"upkeep" : 2500,
		"unlocked" : false,
		"layer" : 0
	},
	"cp" : {
		"name" : "Coal Plant",
		"description" : "res://Recources/Buildings/Coal Plant/Coal.txt",
		"scene" : preload("res://Recources/Buildings/Coal Plant/coal_plant.tscn"),
		"cursor" : preload("res://Recources/Buildings/Coal Plant/coal_plant_cursor.tscn"),
		"price" : 8000,
		"generation" : 2000,
		"pollution" : 1,
		"upkeep" : 1200,
		"unlocked" : true,
		"layer" : 0
	}
}

var button_to_id = {1 : "wt", 2 : "sp", 3 : "nc", 6 : "cp", 7 : "gt"}
var color_modifier = {0 : 0.25, 1 : 0.5, 2 : 0.75, 3 : 1.25, 4 : 1.75}

var infoPanel = preload("res://Scenes/UI/infoPanel.tscn")

var is_mouse_over_ui = false

var button_selected = 0
var buildmode = false
var demolishmode = false

var current_build_model
var current_build_type

var GRID_LAYER = 12
var TREE_LAYER = 7
var RIVER_LAYER = 13
var SEAA_LAYER = 14
var SEAB_LAYER = 15
var SEAC_LAYER = 16

@onready var ui_manager = get_node("Camera2D/UI")
@onready var tilemap = $TileMap

func _ready():
	#Set tree array
	forest_tiles = cells_to_cords($TileMap.get_used_cells(TREE_LAYER))
	river_tiles = cells_to_cords($TileMap.get_used_cells(RIVER_LAYER))
	seaA_tiles = cells_to_cords($TileMap.get_used_cells(SEAA_LAYER))
	seaB_tiles = cells_to_cords($TileMap.get_used_cells(SEAB_LAYER))
	seaC_tiles = cells_to_cords($TileMap.get_used_cells(SEAC_LAYER))
	
	#Set buildable positions minus river
	var buildable_tiles_i = $TileMap.get_used_cells(GRID_LAYER)
	for tile in buildable_tiles_i:
		if tilemap.get_cell_source_id(GRID_LAYER, tile) != 3:
			buildable_tiles.append(Vector2((tile.x*128)+64,(tile.y*128)+64))
	
	set_process_input(true)

func cells_to_cords(arr):
	var a = []
	for i in arr:
		a.append(Vector2((i.x*128)+64,(i.y*128)+64))
	return a

func cords_to_cell(pos : Vector2) -> Vector2i:
	return Vector2i(((pos.x-64)/128),((pos.y-64)/128))

func update_hoverable():
	hoverable_items.clear()
	hoverable_items.append_array(buildings_created)
	for city in citymanager.cities:
		if city.visible:
			hoverable_items.append(city)

func showornothover():
	hover.visible = false
	if button_selected == 0 and not is_mouse_over_ui:
		var mouse_pos_snap = snap_to_grid(get_global_mouse_position())
		update_hoverable()
		for item in hoverable_items:
			if item.position == mouse_pos_snap:
				hover.visible = true
				hover.position = item.position

func _input(event):
	showornothover()
	
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if button_selected == 0:
				check_for_info(snap_to_grid(get_global_mouse_position()))
			if buildmode:
				var mouse_pos = get_global_mouse_position()
				place_building(mouse_pos, button_to_id[button_selected], true)
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
				var newPanel = infoPanel.instantiate()
				ui.add_child(newPanel)
				newPanel.followNode = building
				newPanel.type = "building"
				newPanel.load_info()
		for city in $TileMap/Cities.cities:
			if city.position == position and city.is_visible_in_tree():
				var newPanel = infoPanel.instantiate()
				newPanel.type = "city"
				ui.add_child(newPanel)
				newPanel.followNode = city
				newPanel.load_info()
		for tree in forest_tiles:
			if tree == position:
				var newPanel = infoPanel.instantiate()
				newPanel.type = "tree"
				ui.add_child(newPanel)
				newPanel.followPos = tree
				newPanel.load_info()
		for seaTileA in seaA_tiles:
			if seaTileA == position:
				var newPanel = infoPanel.instantiate()
				newPanel.type = "seaA"
				ui.add_child(newPanel)
				newPanel.followPos = seaTileA
				newPanel.load_info()
		for seaTileB in seaB_tiles:
			if seaTileB == position:
				var newPanel = infoPanel.instantiate()
				newPanel.type = "seaB"
				ui.add_child(newPanel)
				newPanel.followPos = seaTileB
				newPanel.load_info()
		for seaTileC in seaC_tiles:
			if seaTileC == position:
				var newPanel = infoPanel.instantiate()
				newPanel.type = "seaC"
				ui.add_child(newPanel)
				newPanel.followPos = seaTileC
				newPanel.load_info()
		for river in river_tiles:
			if river == position:
				var newPanel = infoPanel.instantiate()
				newPanel.type = "river"
				ui.add_child(newPanel)
				newPanel.followPos = river
				newPanel.load_info()

func _process(_delta):
	button_selected = ui_manager.current_button_selected
	
	SimulationManager.buildings = buildings_created
	# Set buildmode based on button_selected
	buildmode = button_selected in [1, 2, 3, 6, 7]
	# Set demolishmode based on button_selected
	demolishmode = (button_selected == 5)
	
	if buildmode:
		showBuildUI()
	else:
		if current_build_model != null:
			current_build_model.queue_free()
			current_build_model = null
			current_build_type = null

func check_for_tree(positions):
	for tree in forest_tiles:
		if tree == positions:
			var grid_pos = cords_to_cell(tree)
			tilemap.erase_cell(TREE_LAYER, grid_pos)
			forest_tiles.erase(grid_pos)

func showBuildUI():
	var id = button_to_id[button_selected]
	if current_build_type != id:
		current_build_type = id
		if current_build_model != null:
			current_build_model.queue_free()
		current_build_model = building_data[id]["cursor"].instantiate()
		add_child(current_build_model)
	elif current_build_type == id:
		if current_build_model != null:
			current_build_model.position = snap_to_grid(get_global_mouse_position())
			
			var price_tag
			var energy_tag
			var position_tag
			
			var price_can = false
			var position_can = false
			
			var childses
			
			if id == "cp":
				childses = current_build_model.get_child(1).get_child(0).get_child(0).get_children()
			else:
				childses = current_build_model.get_child(1).get_child(0).get_children()
			
			for childs in childses:
				if childs.name ==  "price":
					price_tag = childs
				if childs.name == "position":
					position_tag = childs
				if childs.name == "energy":
					energy_tag = childs
			
			if price_tag != null:
				if money.is_enough_money(building_data[id]["price"]):
					price_tag.text = "Price: " + str(building_data[id]["price"])
					price_tag.modulate = Color(0.5,255,0.5,1)
					price_can = true
				else:
					price_can = false
					price_tag.text = "Not enough money, price: " + str(building_data[id]["price"])
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
				var layer_num = building_data[id]["layer"]
				var modifier = get_position_modifier(layer_num, grid_position)
				var building_base_production = building_data[id]["generation"]
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

func place_building(positiond, buildingID, pay:bool):
	print(positiond)
	var grid_position = snap_to_grid(positiond)
	if grid_position not in occupied_positions and !is_mouse_over_ui and grid_position in buildable_tiles:
		var building_id = buildingID
		if pay:
			if money.is_enough_money(building_data[building_id]["price"]):
				if building_data[building_id]["unlocked"]:
					money.modify_money(-building_data[building_id]["price"])
					var new_building = building_data[building_id]["scene"].instantiate()
					buildings_created.append(new_building)
					building_container.add_child(new_building)
					new_building.position = grid_position
					
					#Get modifier
					var layer = building_data[building_id]["layer"]
					
					new_building.output_modifier = get_position_modifier(layer, grid_position)
					
					occupied_positions[grid_position] = new_building
					check_for_tree(grid_position)
					
					print("New building ", new_building, " created on ", str(grid_position) ,".")
				else:
					print("Building not avalible.")
			else:
				print("WE NEEED MONEHH ARTHUR AND GADDAM FAITH")
		elif not pay:
			var new_building = building_data[building_id]["scene"].instantiate()
			buildings_created.append(new_building)
			building_container.add_child(new_building)
			new_building.position = grid_position
			
			#Get modifier
			var layer = building_data[building_id]["layer"]
			
			new_building.output_modifier = get_position_modifier(layer, grid_position)
			
			occupied_positions[grid_position] = new_building
			print("Initial Building Created: ", new_building, " created on ", str(grid_position) ,".")

func snap_to_grid(positions: Vector2) -> Vector2:
	var map_coords = tilemap.local_to_map(positions)
	
	var tile_center = tilemap.map_to_local(map_coords)
	return tile_center

func load_text_file(path: String) -> String:
	var file = FileAccess.open(path, FileAccess.READ)
	var content = file.get_as_text()
	return content

func get_position_modifier(layer, position)-> float:
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

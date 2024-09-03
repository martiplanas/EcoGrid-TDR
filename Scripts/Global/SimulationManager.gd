extends Node

var line_container  = []

@onready var building_data = {
	"wt" : {
		"description" : "res://Recources/Buildings/Wind Turbine/Wind.txt",
		"scene" : preload("res://Recources/Buildings/Wind Turbine/wind_turbine.tscn"),
		"cursor" : preload("res://Recources/Buildings/Wind Turbine/wind_turbine_cursor.tscn"),
		"button" : $Camera2D/UI/ToolBar/VBoxContainer/Building_wt,
		"price" : 1200,
		"generation" : 500, 
		"unlocked" : true,
	},
	"sp" : {
		"description" : "res://Recources/Buildings/Solar Panels/Solar.txt",
		"scene" : preload("res://Recources/Buildings/Solar Panels/solar-panel-2.tscn"),
		"cursor" : preload("res://Recources/Buildings/Solar Panels/solar_panel_cursor.tscn"),
		"button" : $Camera2D/UI/ToolBar/VBoxContainer/Building_sp,
		"price" : 500,
		"generation" : 200,
		"unlocked" : true,
	},
	"nc" : {
		"description" : "res://Recources/Buildings/Nuclear Power Plant/Nuclear.txt",
		"scene" : preload("res://Recources/Buildings/Nuclear Power Plant/nuclear_plant.tscn"),
		"cursor" : preload("res://Recources/Buildings/Nuclear Power Plant/nuclear_plant_cursor.tscn"),
		"button" : $Camera2D/UI/ToolBar/VBoxContainer/Building_nc,
		"price" : 100000,
		"generation" : 10000,
		"unlocked" : true,
	},
	"gt" : {
		"description" : "res://Recources/Buildings/Geotermical/Geo.txt",
		"scene" : preload("res://Recources/Buildings/Geotermical/Geothermal.tscn"),
		"cursor" : preload("res://Recources/Buildings/Geotermical/Geothermal_cursor.tscn"),
		"button" :  $Camera2D/UI/ToolBar/VBoxContainer/Building_wt,
		"price" : 5000,
		"generation" : 1500,
		"unlocked" : true,
	},
	"hp" : {
		"description" : "res://Recources/Buildings/Hydropower/Hydro.txt",
		"scene" : preload("res://Recources/Buildings/Hydropower/Hydropower.tscn"),
		"cursor" : preload("res://Recources/Buildings/Hydropower/Hydropower_cursor.tscn"),
		"button" :  $Camera2D/UI/ToolBar/VBoxContainer/Building_wt,
		"price" : 10000,
		"generation" : 3000,
		"unlocked" : false,
	}
}

var citydata = {}
var buildings = []

var total_demand = 0
var total_production = 0

var money_per_unit = 0.25

var has_lost = false

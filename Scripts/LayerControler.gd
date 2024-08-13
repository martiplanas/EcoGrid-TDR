extends Panel

@onready var tilemap =$"../../../TileMap"

var buttons = {6 : $HBoxContainer/WindView, 8 : $HBoxContainer/SunView}

const GRID_LAYER:int = 9
const WIND_LAYER:int = 6
const GEO_LAYER:int = 7
const SOLAR_LAYER:int = 8

#0 = none, 1 = WIND, 2 = SUN
func set_layer(layer):
	if layer == 0:
		if tilemap.is_layer_enabled(WIND_LAYER):
			tilemap.set_layer_enabled(WIND_LAYER, false)
		if tilemap.is_layer_enabled(SOLAR_LAYER):
			tilemap.set_layer_enabled(SOLAR_LAYER, false)
		if tilemap.is_layer_enabled(GEO_LAYER):
			tilemap.set_layer_enabled(GEO_LAYER, false)
	if layer == 1:
		if not tilemap.is_layer_enabled(WIND_LAYER):
			tilemap.set_layer_enabled(WIND_LAYER, true)
		if tilemap.is_layer_enabled(SOLAR_LAYER):
			tilemap.set_layer_enabled(SOLAR_LAYER, false)
		if tilemap.is_layer_enabled(GEO_LAYER):
			tilemap.set_layer_enabled(GEO_LAYER, false)
	if layer == 2:
		if tilemap.is_layer_enabled(WIND_LAYER):
			tilemap.set_layer_enabled(WIND_LAYER, false)
		if not tilemap.is_layer_enabled(SOLAR_LAYER):
			tilemap.set_layer_enabled(SOLAR_LAYER, true)
		if tilemap.is_layer_enabled(GEO_LAYER):
			tilemap.set_layer_enabled(GEO_LAYER, false)
	if layer == 3:
		if tilemap.is_layer_enabled(WIND_LAYER):
			tilemap.set_layer_enabled(WIND_LAYER, false)
		if tilemap.is_layer_enabled(SOLAR_LAYER):
			tilemap.set_layer_enabled(SOLAR_LAYER, false)
		if not tilemap.is_layer_enabled(GEO_LAYER):
			tilemap.set_layer_enabled(GEO_LAYER, true)

func _on_basic_view_pressed():
	set_layer(0)

func _on_wind_view_pressed():
	set_layer(1)

func _on_sun_view_pressed():
	set_layer(2)

func _on_geo_view_pressed():
	set_layer(3)

func _on_building_wt_pressed():
	set_layer(1)

func _on_mouse_mode_pressed():
	set_layer(0)

func _on_building_sp_pressed():
	set_layer(2)

func _on_building_nc_pressed():
	set_layer(0)

func _on_line_creator_pressed():
	set_layer(0)

func _on_demolisher_pressed():
	set_layer(0)

func _on_building_hp_pressed():
	set_layer(0)

func _on_building_gt_pressed():
	set_layer(3)

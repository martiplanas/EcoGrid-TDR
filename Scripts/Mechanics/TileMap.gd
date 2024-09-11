extends TileMap

const GRID_LAYER:int = 12
const WIND_LAYER:int = 8
const GEO_LAYER:int = 9
const SOLAR_LAYER:int = 10

var mouse = 0
@onready var main = $".."

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	mouse = main.button_selected
	
	if mouse == 1 or mouse == 2 or mouse == 3 or mouse == 6 or mouse == 5 or mouse == 7:
		if not is_layer_enabled(GRID_LAYER):
			self.set_layer_enabled(GRID_LAYER, true)
	else:
		if is_layer_enabled(GRID_LAYER):
			self.set_layer_enabled(GRID_LAYER, false)
	
	

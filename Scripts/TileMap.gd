extends TileMap

const GRID_LAYER:int = 6 
var mouse = 0
@onready var main = $".."

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	mouse = main.button_selected
	
	if mouse == 1 or mouse == 2 or mouse == 3 or mouse == 4:
		if not is_layer_enabled(GRID_LAYER):
			self.set_layer_enabled(GRID_LAYER, true)
	else:
		if is_layer_enabled(GRID_LAYER):
			self.set_layer_enabled(GRID_LAYER, false)

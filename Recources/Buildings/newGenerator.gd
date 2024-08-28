extends Node2D

var output_modifier : float
var modified_generation = false
var mod_gen_cache : float
var base_generation : int = 3
var energy_production :int
var id : String
@onready var main = get_node("../")

var state = true

func _process(delta):
	if modified_generation == false and output_modifier != null:
		id = self.get_meta("Type")
		base_generation = main.building_data[id]["generation"]
		modified_generation = true
		energy_production = base_generation*output_modifier
		mod_gen_cache = base_generation*output_modifier

func update_state():
	if state:
		energy_production = mod_gen_cache
	if not state:
		energy_production = 0 

func set_on():
	state = true
	update_state()

func set_off():
	state = false
	update_state()

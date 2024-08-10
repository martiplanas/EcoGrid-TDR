extends Node2D

var output_modifier : float
var modified_generation = false
var base_generation : int = 3
var energy_production :int
var id : String
@onready var main = get_node("../")

func _process(delta):
	if modified_generation == false and output_modifier != null:
		id = self.get_meta("Type")
		base_generation = main.building_data[id]["generation"]
		modified_generation = true
		energy_production = base_generation*output_modifier
extends Node2D

var output_modifier : float
var modified_generation = false
var base_generation : int
var energy_production :int
var id : String

func _ready():
	id = self.get_meta("Type")
	base_generation = SimulationManager.building_data[id]["generation"]

func _process(delta):
	if modified_generation == false and output_modifier != null:
		modified_generation = true
		energy_production = base_generation*output_modifier

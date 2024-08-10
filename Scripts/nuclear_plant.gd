extends Node2D

var output_modifier
var modified_generation = false

func _process(delta):
	if modified_generation == false and output_modifier != null:
		modified_generation = true
		var modified_production = self.get_meta("Energy_Production")*output_modifier
		self.set_meta("Energy_Production", modified_production)

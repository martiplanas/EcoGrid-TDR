extends Node2D

var output_modifier : float
var modified_generation = false
var mod_gen_cache : float
var base_generation : int = 3
var energy_production :int
var id : String
@onready var main = get_node("../../")

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

func update_apperence():
	if state:
		self.modulate = Color(1,1,1)
	if not state:
		self.modulate = Color(0.5,0.5,0.5)
	
	for child in self.get_children():
		if child is AnimationPlayer:
			if state:
				child.play()
			elif not state:
				child.stop()

func set_animation_speed(speed:float):
	for child in self.get_children():
		if child is AnimationPlayer:
			child.speed_scale = speed

func set_on():
	state = true
	update_state()
	update_apperence()

func set_off():
	state = false
	update_state()
	update_apperence()

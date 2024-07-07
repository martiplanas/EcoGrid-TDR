extends Node2D

var cities = []
var citypos = []
# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		cities.append(child)
		child.modulate = Color(0.75,0.75,0.75,0.5)
		citypos.append(child.position)
	
	var parent = get_parent()
	parent = parent.get_parent()
	
	var i = 0
	for city in cities:
		parent.occupied_positions[citypos[i]]=city
		i += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

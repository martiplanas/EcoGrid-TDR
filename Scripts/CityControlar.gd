extends Node2D

var cities = []
var citypos = []

func loadCities():
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

extends Node2D

var cities = []
var citypos = []

func loadCities():
	for child in get_children():
		cities.append(child)
		citypos.append(child.position)
	
	var parent = get_parent()
	parent = parent.get_parent()
	
	var i = 0
	for city in cities:
		if city.is_visible_in_tree():
			parent.occupied_positions[citypos[i]]=city
		i += 1

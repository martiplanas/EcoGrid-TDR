extends Node2D

var cities = []
var citypos = []
@onready var money = $"../../Camera2D/UI/MoneyDisplay"
@onready var generatorcontroller = $"../../Generators"

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

func get_money():
	var total_moneh : int = 0
	
	for child in self.get_children():
		if child.visible and child != null:
			child.update_money()
			total_moneh = total_moneh + child.moneh_generation
	
	if total_moneh != 0:
		money.modify_money(total_moneh)

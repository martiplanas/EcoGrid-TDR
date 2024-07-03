extends Node2D

var ID: String
var cityname: String
var energy_consumption: float

func _ready():
	print("City %s initialized at position %s with energy consumption %f" % [name, position, energy_consumption])

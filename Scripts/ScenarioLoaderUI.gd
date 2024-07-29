extends Control

var buttonCAT
var buttonCAL
var buttonSCD
var buttonLoad

var currentScenarioSelected = 0
# 0 = none, 1 = CAT, 2 = CAL, 3 = SCD

# Called when the node enters the scene tree for the first time.
func _ready():
	buttonCAT = $Panel/VBoxContainer/Scenarios/Catalunya
	buttonCAL = $Panel/VBoxContainer/Scenarios/California
	buttonSCD = $Panel/VBoxContainer/Scenarios/Scandinavia
	buttonLoad = $Panel/VBoxContainer/BotomBar/LoadScenario

func _on_button_pressed():
	# Determine which button is pressed and print its name or ID
	if buttonCAT.button_pressed:
		currentScenarioSelected = 1
	elif buttonCAL.button_pressed:
		currentScenarioSelected = 2
	elif buttonSCD.button_pressed:
		currentScenarioSelected = 3
	elif not buttonCAL.button_pressed and not buttonCAT.button_pressed and not buttonSCD.button_pressed:
		currentScenarioSelected = 0

func _process(delta):
	if currentScenarioSelected == 0:
		buttonLoad.disabled = true
	else:
		buttonLoad.disabled = false

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/UI/Main Menu.tscn")

func _on_load_scenario_pressed():
	if currentScenarioSelected == 1:
		get_tree().change_scene_to_file("res://Scenes/Main Scenes/Game.tscn")

func _on_catalunya_button_down():
	_on_button_pressed()
func _on_catalunya_button_up():
	_on_button_pressed()
func _on_california_button_down():
	_on_button_pressed()
func _on_california_button_up():
	_on_button_pressed()
func _on_scandinavia_button_up():
	_on_button_pressed()
func _on_scandinavia_button_down():
	_on_button_pressed()

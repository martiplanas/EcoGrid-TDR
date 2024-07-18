extends Node2D

@onready var lines = [$L1,$L2,$L3,$L4,$L5,$L6,$L7]

var linesUsed = [false, false, false, false, false, false, false]
var currentLineInCreation
var creatingLine = false
@onready var mainScene = get_node("../")
@onready var camera = get_node("../Camera2D")
@onready var cityManager = get_node("../TileMap/Cities")
var previousTile

# Called when the node enters the scene tree for the first time.
func _ready():
	hide_all_lines()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#Line creation follow mouse etc sys
	if creatingLine && Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		line_in_creation()
	elif creatingLine:
		stop_creating_line()
	
	check_actions()
	
	if !creatingLine:
		clear_empty_lines()

func newLineP(firstPosition: Vector2):
	var hasLineCreated = false
	var i = 0
	for line in lines:
		if not linesUsed[i]:
			if not hasLineCreated:
				hasLineCreated = true
				print("New line initalitiated. Line: ", line, ", ", linesUsed[i])
				creatingLine = true
				print("Ping")
				print(lines[i])
				lines[i].add_point(firstPosition)
				start_creating_line(lines[i], i)
		else:
			print("Line ", line, " ocupied")
		i += 1
	
	if not hasLineCreated:
		print("Line cound not be created, no lines avalible.")

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT and mainScene.button_selected == 4:
			for city in cityManager.cities:
				if city.position == mainScene.snap_to_grid(get_global_mouse_position()):
					print("NEW LINE IS BEING CREATED!")
					newLineP(city.position)

func clear_empty_lines():
	var i = 0
	for line in lines:
		if line.get_point_count() == 1:
			print("Line ", line, " that had only one point has been cleared.")
			line.remove_point(0)
			linesUsed[i] = false
		i += 1

func line_in_creation():
	currentLineInCreation.set_point_position(currentLineInCreation.get_point_count() - 1, get_global_mouse_position())

func stop_creating_line():
	print("Removed point number: ", currentLineInCreation.get_point_count())
	currentLineInCreation.remove_point(currentLineInCreation.get_point_count()-1)
	print("Stopped Creating line: ", currentLineInCreation)
	creatingLine = false
	currentLineInCreation = null

func start_creating_line(line, lineNum):
	creatingLine = true
	line.add_point(get_global_mouse_position())
	currentLineInCreation = line
	print("Line ", currentLineInCreation, " has started to be created")
	line.visible = true
	linesUsed[lineNum] = true

func modify_line():
	var line_array = get_line_points_array(currentLineInCreation)
	var delete_point = false
	var pos
	
	for building in mainScene.buildings_created:
		if building.position == mainScene.snap_to_grid(get_global_mouse_position()):
			for point in line_array:
				if building.position == point:
					pos = building.position
					delete_point = true
			
			if not delete_point:
				currentLineInCreation.add_point(building.position, currentLineInCreation.get_point_count()-1)
			elif delete_point:
				currentLineInCreation.remove_point(get_point_index(currentLineInCreation, pos))

func check_actions():
	var new_tile = mainScene.snap_to_grid(get_global_mouse_position())
	
	if previousTile == null:
		if not get_global_mouse_position() == null:
				previousTile = mainScene.snap_to_grid(get_global_mouse_position())
	
	if new_tile != previousTile:
		if not previousTile == null and not new_tile == null:
			if creatingLine:
				modify_line()
			previousTile = new_tile

func get_line_points_array(line):
	var points = []
	for i in range(line.get_point_count()):
		points.append(line.get_point_position(i))
	return points

func hide_all_lines():
	print("All lines has been hidden")
	for line in lines:
		line.visible = false
	set_process(true)

func clear_line(linec):
	var i = 0
	for line in lines:
		if line == linec:
			linesUsed[i] = false
			linec.clear_points()
		
		i += 1

func get_point_index(line, point):
	for p in range(line.get_point_count()):
		if line.get_point_position(p+1) == point:
			return p+1

extends Node2D

@onready var lines = [$L1,$L2,$L3,$L4,$L5,$L6,$L7]
var currentLineInCreation
var creatingLine = false
@onready var mainScene = get_node("../")
@onready var cityManager = get_node("../TileMap/Cities")

# Called when the node enters the scene tree for the first time.
func _ready():
	for line in lines:
		line.visible = false
	set_process(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if creatingLine:
		var mouse_position = get_viewport().get_mouse_position()
		currentLineInCreation.set_point_position(currentLineInCreation.get_point_count() - 1, mouse_position)

func newLine(firstPosition: Vector2):
	print("F")
	lines[0].addPoint(firstPosition)
	lines[0].visible = true
	currentLineInCreation = lines[0]
	creatingLine = true

func _input(event):
	if event is InputEventMouseButton:
		print("B")
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT and mainScene.button_selected == 4:
			print("C")
			print(cityManager.cities)
			for city in cityManager.cities:
				print("D")
				print("City position: ", city.position)
				print("Mouse pos snaped: ", mainScene.snap_to_grid(event.position))
				if city.position == mainScene.snap_to_grid(event.position):
					print("E")
					newLine(city.position)

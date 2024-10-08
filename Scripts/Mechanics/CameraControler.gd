extends Camera2D

# Movement speed
@export var base_move_speed: float = 350.0

# Zoom variables
@export var zoom_speed: float = 0.01
@export var min_zoom: float = 0.15
@export var max_zoom: float = 1

@onready var ui = $UI

func _process(delta: float) -> void:
	# Handle camera movement
	var move_speed = base_move_speed * (1/zoom.x)*2
	var movement = Vector2.ZERO
	
	if Input.is_action_pressed("camera_left"):
		movement.x -= 1
	if Input.is_action_pressed("camera_right"):
		movement.x += 1
	if Input.is_action_pressed("camera_up"):
		movement.y -= 1
	if Input.is_action_pressed("camera_down"):
		movement.y += 1

	position += movement * move_speed * delta

	 #Handle camera zoom
	if Input.is_action_pressed("zoom_in"):
		zoom = (zoom - Vector2.ONE * zoom_speed).clamp(Vector2.ONE * min_zoom, Vector2.ONE * max_zoom)
	if Input.is_action_pressed("zoom_out"):
		zoom = (zoom + Vector2.ONE * zoom_speed).clamp(Vector2.ONE * min_zoom, Vector2.ONE * max_zoom)
	
	scale = Vector2(1 / zoom.x, 1 / zoom.y)
	
	position.x = clamp(position.x, -500, 4000)
	position.y = clamp(position.y, -500, 4000)

func update_scale():
	scale = Vector2(1 / zoom.x, 1 / zoom.y)

extends Area2D

@onready var ui_manager = get_node("../../../Camera2D/UI")
@onready var lines_manager = get_node("../../../Lines")


func _ready():
	# Optional: Connect the input event if you prefer to handle input through the scene tree
	set_process_input(true)

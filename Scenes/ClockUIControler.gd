extends Panel

@onready var expandButton = $ClockExpand
@onready var panel = $Panel

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if expandButton.button_pressed:
		panel.visible = true
	else:
		panel.visible = false

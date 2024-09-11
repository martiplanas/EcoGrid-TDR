extends Panel

@onready var expandButton = $ClockExpand
@onready var panel = $Panel

func _process(delta):
	if expandButton.button_pressed:
		panel.visible = true
	else:
		panel.visible = false

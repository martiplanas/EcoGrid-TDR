extends Panel

var tutorial = preload("res://Scenes/UI/tutorialManager.tscn")
@onready var ui = $"../"


func _on_buttonok_pressed() -> void:
	if SimulationManager.tutorial_enabled:
		var tt = tutorial.instantiate()
		ui.add_child(tt)
	self.queue_free()

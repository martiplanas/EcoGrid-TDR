extends Panel

var tutorial = preload("res://Scenes/UI/tutorialManager.tscn")
@onready var ui = $"../"


func _on_buttonok_pressed() -> void:
	var tt = tutorial.instantiate()
	ui.add_child(tt)
	self.queue_free()

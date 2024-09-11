extends Panel

func _on_pause_pressed() -> void:
	self.visible = true

func _on_fast_pressed() -> void:
	self.visible = false

func _on_play_pressed() -> void:
	self.visible = false

func set_pause():
	self.visible = true

func set_play():
	self.visible = false
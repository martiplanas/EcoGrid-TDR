extends Control

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Main Scenes/scenario selector.tscn")

func _on_dailly_challange_button_pressed():
	pass # Replace with function body.

func _on_settings_button_pressed():
	pass # Replace with function body.


func _on_exit_button_pressed():
	get_tree().quit()

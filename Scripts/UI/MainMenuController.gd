extends Control

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/UI/scenario selector.tscn")

func _on_dailly_challange_button_pressed():
	pass

func _on_settings_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/UI/options_menu.tscn")


func _on_exit_button_pressed():
	get_tree().quit()

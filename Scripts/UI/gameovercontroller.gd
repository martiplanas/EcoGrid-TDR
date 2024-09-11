extends Panel


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_replay_pressed():
	get_tree().paused = false
	SimulationManager.has_lost = false
	get_tree().change_scene_to_file("res://Scenes/Main Scenes/Game.tscn")

func _on_mainmenu_pressed():
	get_tree().paused = false
	SimulationManager.has_lost = false
	get_tree().change_scene_to_file("res://Scenes/UI/Main Menu.tscn")

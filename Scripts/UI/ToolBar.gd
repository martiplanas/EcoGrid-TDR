extends PanelContainer

@onready var button_index = {
	"mouse" : {
		"node" : $VBoxContainer/MouseMode,
		"normal" : "res://Recources/UI/ToolBar/mouse.png",
		"hover" : "res://Recources/UI/ToolBar/mouseHover.png",
		"pressed" : "res://Recources/UI/ToolBar/mouseHighlit.png"
	}
}



func _on_mouse_mode_button_down():
	button_index["mouse"]["node"].icon = button_index["mouse"]["pressed"]

func _on_mouse_mode_button_up():
	button_index["mouse"]["node"].icon = button_index["mouse"]["normal"]

func _on_mouse_mode_mouse_entered():
	button_index["mouse"]["node"].icon = button_index["mouse"]["hover"]

func _on_mouse_mode_mouse_exited():
	button_index["mouse"]["node"].icon = button_index["mouse"]["normal"]

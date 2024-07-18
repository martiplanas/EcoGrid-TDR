extends Panel

@onready var lines_nodes = [$LinesBox/L1Box/L1, $LinesBox/L2Box/L2,$LinesBox/L3Box/L3, $LinesBox/L4Box/L4, $LinesBox/L5Box/L5, $LinesBox/L6Box/L6, $LinesBox/L7Box/L7]
@onready var lines_script = $"../../../Lines"
var lines_colors = [Color(1, 0.231, 0.188),Color(1, 0.584, 0),Color(1, 0.8, 0), Color(0, 0.478, 1), Color(0.345, 0.337, 0.839), Color(0.686, 0.322, 0.871), Color(0.635, 0.518, 0.369)]
@onready var lines_buttons = [$LinesBox/L1Box/L1CloseButton, $LinesBox/L2Box/L2CloseButton, $LinesBox/L3Box/L3CloseButton, $LinesBox/L4Box/L4CloseButton, $LinesBox/L5Box/L5CloseButton, $LinesBox/L6Box/L6CloseButton, $LinesBox/L7Box/L7CloseButton]

var usedLine = load("res://Sprites/UI/lineCreatedCircle.png")
var unusedLine = load("res://Sprites/UI/lineUNCreatedCircle.png")

func _ready():
	var i = 0
	for line in lines_nodes:
		line.modulate = lines_colors[i]
		i += 1

func _process(delta):
	var i = 0
	for line in lines_script.linesUsed:
		if line:
			lines_nodes[i].texture = usedLine
			lines_nodes[i].modulate = lines_colors[i]
			lines_buttons[i].visible = true
		else:
			lines_nodes[i].texture = unusedLine
			lines_nodes[i].modulate = Color(0,0,0,1)
			lines_buttons[i].visible = false
		i += 1

func clear_line(liness):
	lines_script.clear_line(liness)
	


func _on_l_1_close_button_pressed():
	clear_line($"../../../Lines/L1")
func _on_l_2_close_button_pressed():
	clear_line($"../../../Lines/L2")
func _on_l_3_close_button_pressed():
	clear_line($"../../../Lines/L3")
func _on_l_4_close_button_pressed():
	clear_line($"../../../Lines/L4")
func _on_l_5_close_button_pressed():
	clear_line($"../../../Lines/L5")
func _on_l_6_close_button_pressed():
	clear_line($"../../../Lines/L6")
func _on_l_7_close_button_pressed():
	clear_line($"../../../Lines/L7")

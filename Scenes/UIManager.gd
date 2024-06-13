extends Control

var current_button_selected = 0;

@onready var main = get_parent().get_parent()

@onready var b0 = $PanelContainer/VBoxContainer/MouseMode
@onready var b1 = $PanelContainer/VBoxContainer/Building_wt
@onready var b2 = $PanelContainer/VBoxContainer/Building_sp
@onready var b3 = $PanelContainer/VBoxContainer/Building_nc
@onready var b4 = $PanelContainer/VBoxContainer/Line_creator
@onready var b5 = $PanelContainer/VBoxContainer/Demolisher

var buttons = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	buttons[0] = b0
	buttons[1] = b1
	buttons[2] = b2
	buttons[3] = b3
	buttons[4] = b4
	buttons[5] = b5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for b in buttons:
		if b != current_button_selected:
			buttons[b].button_pressed = false
		elif b == current_button_selected:
			buttons[b].button_pressed = true

	b1.set_text(str(main.wt_avalible))
	b2.set_text(str(main.sp_avalible))
	b3.set_text(str(main.nc_avalible))
 
func _on_mouse_mode_pressed():
	current_button_selected = 0;

func _on_building_wt_pressed():
	current_button_selected = 1;

func _on_building_sp_pressed():
	current_button_selected = 2;

func _on_building_nc_pressed():
	current_button_selected = 3;

func _on_line_creator_pressed():
	current_button_selected = 4;

func _on_demolisher_pressed():
	current_button_selected = 5;

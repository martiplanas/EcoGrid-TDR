extends Control

var current_button_selected = 0;

@onready var main = get_parent().get_parent()

@onready var b0 = $ToolBar/VBoxContainer/MouseMode
@onready var b1 = $ToolBar/VBoxContainer/Building_wt
@onready var b2 = $ToolBar/VBoxContainer/Building_sp
@onready var b3 = $ToolBar/VBoxContainer/Building_nc
@onready var b4 = $ToolBar/VBoxContainer/Line_creator
@onready var b5 = $ToolBar/VBoxContainer/Demolisher
@onready var b6 = $ToolBar/VBoxContainer/Building_hp
@onready var b7 = $ToolBar/VBoxContainer/Building_gt

@onready var pauseMenu = $PauseMenu

var isPauseMenuActive = false

var buttons = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	current_button_selected = 0
	buttons[0] = b0
	buttons[1] = b1
	buttons[2] = b2
	buttons[3] = b3
	buttons[4] = b4
	buttons[5] = b5
	buttons[6] = b6
	buttons[7] = b7

func _input(event):
	if event is InputEventKey and event.is_action_pressed("ui_cancel"):
		if isPauseMenuActive:
			isPauseMenuActive = false
			get_tree().paused = false
		else:
			isPauseMenuActive = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for b in buttons:
		if b != current_button_selected:
			buttons[b].button_pressed = false
		elif b == current_button_selected:
			buttons[b].button_pressed = true
	
	var i = 0
	
	if SimulationManager.has_lost == false:
		#PAUSE MENU STUFF
		if isPauseMenuActive:
			pauseMenu.visible = true
			get_tree().paused = true
		else:
			pauseMenu.visible = false
			get_tree().paused = false
	
	update_ToolBar()

func update_ToolBar():
	pass
	#$ToolBar.size = Vector2(64,2)
	#$ToolBar.position = Vector2(1075, ((self.size.y - $ToolBar.size.y) / 2) +  6)

func _on_mouse_mode_pressed():
	current_button_selected = 0;

func _on_building_wt_pressed():
	current_button_selected = 1;

func _on_building_sp_pressed():
	current_button_selected = 2;

func _on_building_gt_pressed():
	current_button_selected = 7

func _on_building_hp_pressed():
	current_button_selected = 6

func _on_building_nc_pressed():
	current_button_selected = 3;

func _on_line_creator_pressed():
	current_button_selected = 4;

func _on_demolisher_pressed():
	current_button_selected = 5;

func _on_pause_button_pressed():
	if isPauseMenuActive == false:
		isPauseMenuActive = true


func _on_resume_button_pressed():
	get_tree().paused = false
	isPauseMenuActive = false
func _on_options_button_pressed():
	pass # Replace with function body.
func _on_exit_button_pressed():
	get_tree().paused = false
	get_tree().quit()
func _on_exit_mm_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/UI/Main Menu.tscn")


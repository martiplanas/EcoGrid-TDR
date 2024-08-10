extends Control

@onready var main = $"../../../"

@onready var window_title = $"Panel/Main Container/TopBar/WindowTitle"
@onready var info_text = $"Panel/Main Container/Building info/info"
@onready var info1 = $"Panel/Main Container/Stats/info1"
@onready var info2 = $"Panel/Main Container/Stats/info2"
@onready var info3 = $"Panel/Main Container/Stats/info3"

var have_text_set = false

# Called when the node enters the scene tree for the first time.
func _ready():
	main.is_mouse_over_ui = true
	self.visible = false

func set_texts(a,b,c,d,e):
	if a != null and b != null and c != null:
		window_title.text = a
		info_text.text = b
		
		info1.text = c
		info2.text = d
		info3.text = e
		
		self.visible = true

func close():
	main.is_mouse_over_ui = false
	self.queue_free()

func _input(event):
	if event is InputEventKey and event.is_action_pressed("ui_cancel"):
		close()

func _on_close_button_pressed():
	close()

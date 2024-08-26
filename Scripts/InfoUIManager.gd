extends Control

@onready var main = $"../../../"
@onready var camera =  $"../../../Camera2D"
@onready var ui_element =  $"../../../Camera2D/UI"

@onready var window_title = $"Panel/Main Container/TopBar/TitleBar/TitleBar/WindowTitle"
@onready var info_text = $"Panel/Main Container/Building info/info"
@onready var info1 = $"Panel/Main Container/Stats/info1"
@onready var info2 = $"Panel/Main Container/Stats/info2"
@onready var info3 = $"Panel/Main Container/Stats/info3"

var have_text_set = false

var followNode
var basePosModifier : Vector2 = Vector2(268,-107)

# Called when the node enters the scene tree for the first time.
func _ready():
	#main.is_mouse_over_ui = true
	self.visible = false
	
	for child in ui_element.get_children():
		if child != self:
			if child.get_meta("type") == "panel":
				child.queue_free()

func set_texts(a,b,c,d,e):
	if a != null and b != null and c != null:
		window_title.text = a
		info_text.text = b
		
		info1.text = c
		info2.text = d
		info3.text = e
		
		self.visible = true

func _process(_delta):
	if self.visible:
		self.position = ((followNode.position - camera.position) * camera.zoom.x ) + basePosModifier
		self.position = self.position.clamp(Vector2(-100,12), Vector2(572,200))
		
func close():
	#main.is_mouse_over_ui = false
	self.queue_free()

func _input(event):
	if event is InputEventKey and event.is_action_pressed("ui_cancel"):
		close()

func _on_close_button_pressed():
	close()

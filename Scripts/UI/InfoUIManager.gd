extends Control

@onready var main = $"../../../"
@onready var camera =  $"../../../Camera2D"
@onready var ui_element =  $"../../../Camera2D/UI"
@onready var tilemap = $"../../../TileMap/Cities"
@onready var scnl = $"../../../ScenarioLoader" 

@onready var window_title = $"Panel/Main Container/TopBar/TitleBar/TitleBar/WindowTitle"
@onready var info_text = $"Panel/Main Container/Building info/info"
@onready var info1 = $"Panel/Main Container/Stats/info1"
@onready var info2 = $"Panel/Main Container/Stats/info2"
@onready var info3 = $"Panel/Main Container/Stats/info3"

var can_on_off : bool
var on_button = preload("res://Recources/UI/Info Panel/onButton.png")
var off_button = preload("res://Recources/UI/Info Panel/offButton.png")
@onready var on_off_button = $"Panel/Main Container/TopBar/on_off"
var on_offState

var type_to_description = {
	"river" : "res://Recources/Critique/nature/river.txt",
	"tree" : "res://Recources/Critique/nature/forest (trees).txt",
	"seaA" : "res://Recources/Critique/nature/sea_a.txt",
	"seaB" : "res://Recources/Critique/nature/sea_b.txt",
	"seaC" : "res://Recources/Critique/nature/sea_c.txt",
}

var type: String
var followNode
var followPos
var basePosModifier : Vector2 = Vector2(268,-110)

func set_texts(a,b,c,d,e):
	window_title.text = a
	info_text.text = b
	
	info1.text = c
	info2.text = d
	info3.text = e
	
	self.visible = true

func _process(_delta):
	if self.visible:
		if followPos == null:
			followPos = followNode.position
		self.position = ((followPos - camera.position) * camera.zoom.x ) + Vector2(basePosModifier.x, basePosModifier.y*camera.zoom.y*0.5)
		self.position = self.position.clamp(Vector2(-100,12), Vector2(572,200))
	
func close():
	main.is_mouse_over_ui = false
	self.queue_free()

func _input(event):
	if event is InputEventKey and event.is_action_pressed("ui_cancel"):
		close()

func update_info():
	if type == "building":
		
		var key = followNode.get_meta("Type")
		var title = main.building_data[key]["name"] + " info"
		var description = main.load_text_file(main.building_data[key]["description"])
		var generating_num = "Energy generation: " + str(followNode.energy_production)
		var upkeep_text = "Upkeep cost: " + str(followNode.upkeep)
		
		set_texts(title, description, generating_num, upkeep_text, "")
	elif type == "city":
		var title = followNode.name + " info"
		var description = main.load_text_file(scnl.cities[followNode.name]["description"])
		var info1 = "Energy needs: " + str(followNode.current_needs)
		var info2 = "Population: " + str(scnl.cities[followNode.name]["population"])
		var info3 = "Level: " + str(followNode.level) + "/5"
		
		set_texts(title, description, info1, info2, info3)
	elif type == "river":
		var description = main.load_text_file(type_to_description[type])
		set_texts(type, description, "", "", "")
	elif type == "tree":
		var description = main.load_text_file(type_to_description[type])
		set_texts("Forest", description, "", "", "")
	elif type == "seaA":
		var description = main.load_text_file(type_to_description[type])
		set_texts("Beach coast", description, "", "", "")
	elif type == "seaB":
		var description = main.load_text_file(type_to_description[type])
		set_texts("Sea", description, "", "", "")
	elif type == "seaC":
		var description = main.load_text_file(type_to_description[type])
		set_texts("Deep Sea", description, "", "", "")


func _on_close_button_pressed():
	close()

func load_info():
	self.visible = false
	
	if type == "building":
		on_offState = followNode.state
		set_on_off_color()
	else:
		on_off_button.visible = false
	
	update_info()
	
	for child in ui_element.get_children():
		if child != self:
			if child.get_meta("type") == "panel":
				child.queue_free()

func set_on_off_color():
	if not on_offState:
		on_off_button.icon = off_button
	elif on_offState:
		on_off_button.icon = on_button

func _on_on_off_pressed() -> void:
	if on_offState:
		on_offState = false
		on_off_button.icon = off_button
		followNode.set_off()
	elif not on_offState:
		on_offState = true
		on_off_button.icon = on_button
		followNode.set_on()
	update_info()
	set_on_off_color()


func _on_panel_mouse_entered() -> void:
	main.is_mouse_over_ui = true

func _on_panel_mouse_exited() -> void:
	main.is_mouse_over_ui = false

func _on_on_off_mouse_entered() -> void:
	main.is_mouse_over_ui = true

func _on_on_off_mouse_exited() -> void:
	main.is_mouse_over_ui = false

func _on_close_button_mouse_entered() -> void:
	main.is_mouse_over_ui = true

func _on_close_button_mouse_exited() -> void:
	main.is_mouse_over_ui = false

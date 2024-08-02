extends Area2D

@onready var ui_manager = get_node("../../../Camera2D/UI")
@onready var lines_manager = get_node("../../../Lines")
@onready var update_timer = $ChangeTime
@onready var timer = get_node("../../../TimerJesus")

var first_hour
var first_day
var is_upgrading = false

var needs = []
var current_needs

var lines = []

var level = 1

func _ready():
	update_timer.timeout.connect(_on_timer_timeout)

func _process(delta):
	#Remove empty lines
	for li in lines:
		if not li.is_visible_in_tree():
			lines.erase(li)
	
	#Update current needs depending on level	
	if needs.size() == 5:
		if needs[level-1] != current_needs:
			update_needs()
	
	if $TextureProgressBar.value == 100 and is_upgrading == false:
		is_upgrading = true
		first_hour = timer.current_hour
		first_day = timer.current_day
	
	if is_upgrading:
		if not $TextureProgressBar.value == 100:
			is_upgrading = false
			print("STOP UPGRADING")
		
		if first_hour == timer.current_hour and first_day+1 == timer.current_day and is_upgrading:
			print("UPGRADE!")
			is_upgrading = false
			first_day = null
			first_hour = null
			level += 1

func set_deliver(percent):
	$TextureProgressBar.value += percent

func _on_timer_timeout():
	print("UPGRADE CITY ", self.name)

func update_needs():
	current_needs = needs[level-1]

func change_city_level(diference:int):
	level += diference
	update_needs()

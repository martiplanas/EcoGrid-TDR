extends Area2D

@onready var ui_manager = get_node("../../../Camera2D/UI")
@onready var lines_manager = get_node("../../../Lines")
@onready var update_timer = $upgrade
@onready var downgrade_pretimer = $"downgrade pretimer"
@onready var timer = get_node("../../../TimerJesus")

var is_upgrading = false
var upgrade_difference = 0

var needs = []
var current_needs

var lines = []

var level = 1

func _ready():
	update_timer.timeout.connect(_on_timer_timeout)
	downgrade_pretimer.timeout.connect(_begin_downgrade)

func _process(delta):
	#Begin upgrades
	if is_upgrading == false:
		if $TextureProgressBar.value == 100 and level < 5:
			is_upgrading = true
			upgrade_difference = +1
			update_timer.start
		if $TextureProgressBar.value < 50 and level > 1:
			is_upgrading = true
			upgrade_difference = -1
			downgrade_pretimer.start
	
	#Stop upgrading
	if is_upgrading:
		if upgrade_difference == +1:
			if $TextureProgressBar.value != 100:
				update_timer.stop()
				is_upgrading = false
				upgrade_difference = 0
		if upgrade_difference == -1:
			if $TextureProgressBar.value < 50:
				update_timer.stop()
				downgrade_pretimer.stop()
				is_upgrading = false
				upgrade_difference = 0
	
	#Remove empty lines
	for li in lines:
		if not li.is_visible_in_tree():
			lines.erase(li)
	
	#Update current needs depending on level	
	if needs.size() == 5:
		if needs[level-1] != current_needs:
			update_needs()
	
	update_percent()

func _on_timer_timeout():
	level += upgrade_difference
	is_upgrading = false
	upgrade_difference = 0

func update_needs():
	current_needs = needs[level-1]

func change_city_level(diference:int):
	level += diference
	update_needs()

func _begin_downgrade():
	update_timer.start

func update_percent():
	var generated:float = 0
	var percent:float = 0
	
	for line in lines:
		generated += line.energy_generation
	
	percent = (generated * 100) / current_needs
	$TextureProgressBar.value = percent

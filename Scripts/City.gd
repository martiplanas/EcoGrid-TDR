extends Area2D

@onready var ui_manager = get_node("../../../Camera2D/UI")
@onready var lines_manager = get_node("../../../Lines")
@onready var update_timer = $upgrade
@onready var downgrade_pretimer = $"downgrade pretimer"
@onready var timer = get_node("../../../TimerJesus")
@onready var camera =  get_node("../../../Camera2D")
@onready var gameover_screen = get_node("../../../Camera2D/UI/GameoverScreen")
@onready var upgradeprogress = $upgradeProgress
@onready var lose_progress = $loseProgres

const UPGRADE_TIME = 30

const DOWNGRADE_TIME = 60

var moneh_generation : int

var is_upgrading = false
var is_losing_timer = false
var upgrade_difference = 0

var needs = []
var current_needs

var lines = []

var level = 1

func _ready():
	update_timer.timeout.connect(_on_timer_timeout)
	downgrade_pretimer.timeout.connect(_lose)

func _process(delta):
	
	if is_upgrading:
		if upgrade_difference == 1:
			upgradeprogress.visible = true
			upgradeprogress.value = ((UPGRADE_TIME - update_timer.time_left)*100 / UPGRADE_TIME)
	else:
		upgradeprogress.visible = false
	
	if is_losing_timer:
		lose_progress.visible = true
		lose_progress.value = ((DOWNGRADE_TIME - downgrade_pretimer.time_left)*100 / DOWNGRADE_TIME)
	else:
		lose_progress.visible = false
	#Begin upgrades
	if !is_upgrading:
		if $TextureProgressBar.value == 100 and level < 5:
			is_upgrading = true
			upgrade_difference = +1
			update_timer.start()
	if !is_losing_timer:
		if $TextureProgressBar.value < 50 and level != 1:
			is_losing_timer = true
			downgrade_pretimer.start()
			lose_progress.visible = true
	
	#Stop upgrading
	if is_upgrading:
		if upgrade_difference == +1:
			if $TextureProgressBar.value != 100:
				update_timer.stop()
				print("STOP UPGRADING")
				is_upgrading = false
				upgrade_difference = 0
	
	#Remove empty lines
	for li in lines:
		if not li.is_visible_in_tree():
			lines.erase(li)
	$loseProgres
	if is_losing_timer:
		if not downgrade_pretimer.is_stopped():
			if $TextureProgressBar.value > 50 or level == 1:
				is_losing_timer = false
				downgrade_pretimer.stop()
				lose_progress.visible = false
				lose_progress.value = 0
	
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
	if diference == -1:
		diference = false
	level += diference
	update_needs()

func update_percent():
	var generated:float = 0
	var percent:float = 0
	
	for line in lines:
		generated += line.energy_generation
	
	percent = (generated * 100) / current_needs
	$TextureProgressBar.value = percent

func _lose():
	camera.position = self.position
	camera.zoom.x = 0.7
	camera.zoom.y = 0.7
	camera.update_scale()
	gameover_screen.visible = true
	SimulationManager.has_lost = true
	get_tree().paused = true
	print("----------------------------------")
	print("            PAYER LOST            ")
	print("----------------------------------")

func update_money():
	if current_needs != 0 and current_needs != null and $TextureProgressBar.value != null and $TextureProgressBar.value != 0:
		var energy_delivered = ($TextureProgressBar.value / 100) * current_needs
		moneh_generation = energy_delivered * 0.5
	else:
		moneh_generation = 0

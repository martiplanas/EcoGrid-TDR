extends Timer

# Define the time speed
enum TimeSpeed { PAUSED, NORMAL, FAST }

var time_speed = TimeSpeed.NORMAL
var time_multiplier = 1.0

@onready var clockui = get_node("../Camera2D/UI/Clock/AnimationPlayer")
@onready var cities_manager = $"../TileMap/Cities"

var GameSeconds = 0

var current_hour = 0
var current_day = 0

const HOURS_IN_DAY = 24

# Called when the node enters the scene tree for the first time.
func _ready():
	update_timer()

func update_timer():
	match time_speed:
		TimeSpeed.PAUSED:
			time_multiplier = 0
			self.stop()
		TimeSpeed.NORMAL:
			time_multiplier = 1.0
			self.start(3 / time_multiplier)
		TimeSpeed.FAST:
			time_multiplier = 2.0  # You can change this value to adjust fast speed
			self.start(3 / time_multiplier)
	clockui.setTimeSpeed(time_multiplier)

func set_time_speed(new_speed):
	time_speed = new_speed
	update_timer()

# Call these functions to change the speed
func pause_game():
	set_time_speed(TimeSpeed.PAUSED)

func play_game():
	set_time_speed(TimeSpeed.NORMAL)

func fast_forward_game():
	set_time_speed(TimeSpeed.FAST)

func _on_timeout():
	increment_time()
	recolect_line_money()

func _on_pause_pressed():
	pause_game()

func _on_play_pressed():
	play_game()

func _on_fast_pressed():
	fast_forward_game()

func increment_time():
	var print = false
	GameSeconds += 1
	
	current_hour += 1

	if current_hour >= HOURS_IN_DAY:
		current_hour = 0
		current_day += 1
	
	
	# Print current time for debugging
	if print:
		print("Hour: %d, Day: %d" % [current_hour, current_day])

func recolect_line_money():
	for city in cities_manager.cities:
		if city.visible and city != null:
			city.get_money()

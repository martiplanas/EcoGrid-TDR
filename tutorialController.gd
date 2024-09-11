extends Control

@onready var wasdText = $"Tutorial Panel/MarginContainer/VBoxContainer/WASD"
@onready var zoomText = $"Tutorial Panel/MarginContainer/VBoxContainer/ZOOM"
@onready var clickText = $"Tutorial Panel/MarginContainer/VBoxContainer/Click"

@onready var animationPlayer = $"Tutorial Animator"
@onready var waiter = $waiter

var phase = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if phase == 0:
		play_anim("in", wasdText)
		phase = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if waiter.is_stopped() and not animationPlayer.is_playing():
		if event is InputEventKey:
			if event.pressed:  # Check if a key was pressed
				if phase == 1:
					if event.keycode == 87 or event.keycode == 65 or event.keycode == 83 or event.keycode == 68:
						play_anim("out", wasdText)
						waiter.start()
				if phase == 2:
					if event.keycode == 90 or event.keycode == 88:
						play_anim("out", zoomText)
						waiter.start()
		if event is InputEventMouseButton:
			if phase == 3:
				if event.button_index == 1:
						play_anim("out", clickText)
						waiter.start()

func play_anim(name, nodeanim):
	wasdText.visible = false
	zoomText.visible = false
	clickText.visible = false
	nodeanim.visible = true
	animationPlayer.play(name)

func _on_waiter_timeout() -> void:
	if phase == 1:
		play_anim("in", zoomText)
		phase = 2
	elif phase == 2:
		play_anim("in", clickText)
		phase = 3
	elif phase == 3:
		self.queue_free()

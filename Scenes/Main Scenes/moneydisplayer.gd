extends Panel

@onready var moneyUI = $"Monney ammount"

var textmodify = preload("res://Scenes/UI/modify_text_animator.tscn")

#money stuff
var starting_money = 1000
var money:int

func _ready():
	money = starting_money

func _process(delta):
	for child in self.get_children():
		if child.get_child(0) != null:
			if child.get_child(0) is AnimationPlayer:
				if not child.get_child(0).is_playing():
					child.queue_free()

func modify_money(ammonut: int):
	money += ammonut
	var newModify = textmodify.instantiate()
	self.add_child(newModify)
	newModify.get_child(1).text = str(ammonut) + " €"
	moneyUI.text = str(money) + " $"

func is_enough_money(ammonut:int):
	if money != null:
		if ammonut <= money:
			return true
		elif ammonut > money:
			return false
	else:
		return false

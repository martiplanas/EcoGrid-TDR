extends Panel

@onready var moneyUI = $"Monney ammount"

var remove_animation = preload("res://Scenes/UI/modify_text_animator.tscn")
var add_animation = preload("res://Scenes/UI/modify_text_animator_add.tscn")

#money stuff
var money:int

func _ready():
	money = starting_money

func _process(delta):
	for child in self.get_children():
		if child.get_children().size() > 0:
			if child.get_child(0) is AnimationPlayer:
				if not child.get_child(0).is_playing():
					child.queue_free()

func modify_money(ammount: int):
	money += ammount
	if ammount >= 0:
		var newModify = add_animation.instantiate()
		self.add_child(newModify)
		newModify.get_child(1).text = str(ammount) + " €"
		moneyUI.text = str(money) + " $"
	elif ammount < 0:
		var newModify = remove_animation.instantiate()
		self.add_child(newModify)
		newModify.get_child(1).text = str(ammount) + " €"
		moneyUI.text = str(money) + " $"

func is_enough_money(ammonut:int):
	if money != null:
		if ammonut <= money:
			return true
		elif ammonut > money:
			return false
	else:
		return false

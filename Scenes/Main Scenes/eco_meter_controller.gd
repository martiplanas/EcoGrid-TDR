extends TextureProgressBar

@onready var main =  $"../../../"

var generators = []

func update_bar():
	generators = main.buildings_created
	
	var production_eco : float
	var production_cont : float
	var total_production : float
	
	for generator in generators:
		var id : String = generator.id
		if id != null:
			var production = generator.energy_production
			total_production += production
			var contamination_per_one = main.building_data[id]["pollution"]
			
			if contamination_per_one > 0:
				var building_cont_prod = production*contamination_per_one
				var building_eco_prod = production - building_cont_prod
				
				production_cont += building_cont_prod
				production_eco += building_eco_prod
			else:
				production_eco += production
	
	var eco_percent : float = (production_eco / total_production) * 100
	self.value = eco_percent

func _on_timer_jesus_timeout() -> void:
	update_bar()

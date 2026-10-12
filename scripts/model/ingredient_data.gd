extends Resource
class_name IngredientData

@export var ingredient_name: String
@export var fire_energy: float = 0.0
@export var water_energy: float = 0.0
@export var air_energy: float = 0.0
@export var earth_energy: float = 0.0 

func get_energy() -> Energy:
	return Energy.new(
		water_energy, 
		fire_energy, 
		earth_energy,
		air_energy
	)

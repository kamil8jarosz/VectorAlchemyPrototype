class_name Discovery
extends Resource

@export var discovery_name: String
@export_multiline var description: String
@export_multiline var hint: String

@export var min_position: float
@export var max_position: float

@export var unlocked_ingredients: Array[IngredientData]
@export var unlocked_stations: Array[ProcessingStation]
@export var unlocked_discoveries: Array[Discovery]
@export var max_mixture_capacity: int = 0


func contains_position(position: float) -> bool:
	return position >= min_position and position <= max_position

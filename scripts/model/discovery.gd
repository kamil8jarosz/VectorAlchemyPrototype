class_name Discovery
extends Resource

@export var discovery_name: String
@export_multiline var description: String
@export_multiline var hint: String

@export var min_position_x: float
@export var max_position_x: float
@export var min_position_y: float
@export var max_position_y: float
@export var min_energy: Energy


@export var unlocked_ingredients: Array[IngredientData]
@export var unlocked_stations: Array[ProcessingStation]
@export var unlocked_discoveries: Array[Discovery]
@export var max_mixture_capacity: int = 0


func contains_position(position: Vector2) -> bool:
	return (
		position.x >= min_position_x 
		and position.x <= max_position_x
		and position.y >= min_position_y
		and position.y <= max_position_y
	)

func fulfills_energy_req(energy: Energy):
	if not min_energy:
		return true
	
	return (
		energy.fire >= min_energy.fire
		and energy.water >= min_energy.water
		and energy.air >= min_energy.air
		and energy.earth >= min_energy.earth
	)

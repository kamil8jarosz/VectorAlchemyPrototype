class_name Energy
extends Resource

@export var water: float = 0.0
@export var fire: float =  0.0
@export var earth: float = 0.0
@export var air: float = 0.0


func _init(
	_water: float=0.0, 
	_fire: float=0.0,
	_earth: float=0.0,
	_air: float=0.0
):
	water = _water
	fire = _fire
	earth = _earth
	air = _air


func add(other_energy: Energy):
	water += other_energy.water
	fire += other_energy.fire
	earth += other_energy.earth
	air += other_energy.air
	return self


func sub(other_energy: Energy):
	water -= other_energy.water
	fire -= other_energy.fire
	earth -= other_energy.earth
	air -= other_energy.air
	return self


func get_total() -> float:
	return water+fire+air+earth


func get_balance() -> Vector2:
	return Vector2(
		water - fire,
		earth - air
	)

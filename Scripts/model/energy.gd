class_name Energy
extends RefCounted

var water: float
var fire: float


func _init(_water: float=0.0, _fire: float=0.0):
	water = _water
	fire = _fire


func add(other_energy: Energy):
	water += other_energy.water
	fire += other_energy.fire
	return self


func sub(other_energy: Energy):
	water -= other_energy.water
	fire -= other_energy.fire
	return self


func get_balance() -> float:
	return water - fire

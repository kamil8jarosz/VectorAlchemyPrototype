class_name ProcessingStation
extends Resource

var station_name: String = "NONE"

func _init(name: String):
	station_name = name

func process(energy: Energy) -> Energy:
	return energy

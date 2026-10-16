class_name ProcessingStation
extends Resource

@export var station_name: String = "NONE"
@export var texture: Texture2D

func _init(name: String):
	station_name = name

func process(energy: Energy) -> Energy:
	return energy

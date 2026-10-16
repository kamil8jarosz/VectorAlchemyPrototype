class_name StationInventory
extends Control

signal station_selected(station:ProcessingStation)
signal station_unlocked

@onready var stations_grid: VBoxContainer = %StationsGrid

const STATION_ENTRY = preload("uid://h0cgkyyx8407")

var stations: Array[ProcessingStation] = []


func _ready():
	refresh()


func update(alchemy_progress: AlchemyProgress):
	stations = alchemy_progress.unlocked_stations
	refresh()
	if stations.size() > 1:
		station_unlocked.emit()


func refresh():
	for child in stations_grid.get_children():
		child.queue_free()
	
	for station in stations:
		var station_entry := STATION_ENTRY.instantiate()
		station_entry.setup(station)
		station_entry.pressed.connect(
			func():
				station_selected.emit(station)
				hide()
				refresh()
		)
		stations_grid.add_child(station_entry)

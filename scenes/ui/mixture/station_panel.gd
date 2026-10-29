class_name StationPanel
extends PanelContainer

signal select_station_pressed

@onready var select_station_button: TextureButton = %SelectStationButton
@onready var station_label: Label = %StationLabel



const ADD = preload("uid://jfm4oxqmpps2")


func _ready():
	select_station_button.pressed.connect(
		func():
			select_station_pressed.emit()
	)
	
	clear()

func clear():
	select_station_button.texture_normal = ADD
	station_label.text = "Select station"


func display_station(station: ProcessingStation):
	if station == null:
		clear()
		return
	
	select_station_button.texture_normal = station.texture
	station_label.text = station.station_name

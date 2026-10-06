class_name StationEntry
extends Control

@onready var name_label: Label = $NameLabel

var station: ProcessingStation

func setup(value: ProcessingStation):
	station = value
	name_label.text = station.station_name

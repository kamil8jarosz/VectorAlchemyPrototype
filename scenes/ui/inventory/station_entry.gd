class_name StationEntry
extends Control

var station: ProcessingStation

func setup(value: ProcessingStation):
	station = value
	self.text = station.station_name

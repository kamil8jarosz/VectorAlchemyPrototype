extends Control

func setup(station: ProcessingStation):
	self.text = station.station_name
	self.icon = station.texture

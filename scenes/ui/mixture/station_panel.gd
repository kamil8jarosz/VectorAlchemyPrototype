class_name StationPanel
extends PanelContainer

signal select_station_pressed

@onready var select_station_button: TextureButton = %SelectStationButton

@onready var station_label: Label = %StationLabel
@onready var station_air_value: Label = %StationAirValue
@onready var station_fire_value: Label = %StationFireValue
@onready var station_water_value: Label = %StationWaterValue
@onready var station_earth_value: Label = %StationEarthValue
@onready var station_ingredient_texture: TextureRect = $VBoxContainer/HBoxContainer/StationIngredientTexture



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
	station_air_value.hide()
	station_earth_value.hide()
	station_fire_value.hide()
	station_water_value.hide()
	station_ingredient_texture.hide()


func display_station(station: ProcessingStation, ingredient: IngredientData):
	if station == null:
		clear()
		return
	
	select_station_button.texture_normal = station.texture
	station_label.text = station.station_name
	
	if ingredient == null:
		return
	
	station_ingredient_texture.texture = ingredient.texture
	station_ingredient_texture.show()
	
	var energy := station.process(ingredient.get_energy())
	
	setup_energy_label(station_fire_value, energy.fire)
	setup_energy_label(station_water_value, energy.water)
	setup_energy_label(station_earth_value, energy.earth)
	setup_energy_label(station_air_value, energy.air)
	
	station_fire_value.show()
	station_water_value.show()
	station_earth_value.show()
	station_air_value.show()


func setup_energy_label(label: Label, value: float):
	if value == 0.0:
		label.text = ""
	else:
		label.text = "%.0f" % value

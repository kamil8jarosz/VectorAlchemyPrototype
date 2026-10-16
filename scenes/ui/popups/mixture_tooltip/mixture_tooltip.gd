class_name MixtureTooltip
extends Control

@onready var label: Label = $MarginContainer/VBoxContainer/Label

@onready var water_value: Label = %WaterValue
@onready var air_value: Label = %AirValue
@onready var fire_value: Label = %FireValue
@onready var earth_value: Label = %EarthValue

var energy: Energy

func _ready():
	var empty := StyleBoxEmpty.new()
	ThemeDB.get_default_theme().set_stylebox("panel", "TooltipPanel", empty)
	
	water_value.text = "%d" % energy.water
	air_value.text = "%d" % energy.air
	fire_value.text = "%d" % energy.fire
	earth_value.text = "%d" % energy.earth

func setup(_energy: Energy):
	energy = _energy

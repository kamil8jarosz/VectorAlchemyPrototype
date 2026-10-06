extends PanelContainer

signal undo_pressed
signal add_pressed
signal discover_pressed

@onready var ingredient_name: Label = %IngredientName
@onready var ingredient_fire_label: Label = %IngredientFireLabel
@onready var ingredient_water_label: Label = %IngredientWaterLabel
@onready var station_name: Label = %StationName
@onready var station_fire_label: Label = %StationFireLabel
@onready var station_water_label: Label = %StationWaterLabel

@onready var undo_button: Button = $MarginContainer/HBoxContainer/Buttons/UndoButton
@onready var add_button: Button = $MarginContainer/HBoxContainer/Buttons/AddButton
@onready var discover_button: Button = $MarginContainer/HBoxContainer/Buttons/DiscoverButton


func show_ingredient(ingredient: IngredientData):
	ingredient_name.text = ingredient.ingredient_name
	ingredient_fire_label.text = "%s" % ingredient.fire_energy
	ingredient_water_label.text = "%s" % ingredient.water_energy


func show_station(station: ProcessingStation, energy: Energy):
	station_name.text = station.station_name
	station_fire_label.text = "%s" % energy.fire
	station_water_label.text = "%s" % energy.water

func clear():
	ingredient_name.text = "NONE"
	ingredient_fire_label.text = "0.0"
	ingredient_water_label.text = "0.0"
	station_name.text = "NONE"
	station_fire_label.text = "0.0"
	station_water_label.text = "0.0"

func _ready() -> void:
	clear()
	
	undo_button.pressed.connect(func(): undo_pressed.emit())
	add_button.pressed.connect(func(): add_pressed.emit())
	discover_button.pressed.connect(func(): discover_pressed.emit())

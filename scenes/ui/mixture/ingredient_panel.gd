class_name IngredientsPanel
extends PanelContainer

signal select_ingredient_pressed

@onready var select_ingredient_button: TextureButton = %SelectIngredientButton

@onready var ingredient_label: Label = %IngredientLabel
@onready var ingredient_air_value: Label = %IngredientAirValue
@onready var ingredient_fire_value: Label = %IngredientFireValue
@onready var ingredient_water_value: Label = %IngredientWaterValue
@onready var ingredient_earth_value: Label = %IngredientEarthValue

const ADD = preload("uid://jfm4oxqmpps2")


func _ready():
	select_ingredient_button.pressed.connect(
		func(): select_ingredient_pressed.emit()
	)
	
	clear()

func clear():
	ingredient_fire_value.text = ""
	ingredient_water_value.text = ""
	ingredient_air_value.text = ""
	ingredient_earth_value.text = ""
	select_ingredient_button.texture_normal = ADD
	

func display_ingredient(ingredient: IngredientData):
	if ingredient == null:
		clear()
		return
	
	select_ingredient_button.texture_normal = ingredient.texture
	ingredient_label.text = ingredient.ingredient_name
	
	setup_energy_label(ingredient_fire_value, ingredient.fire_energy)
	setup_energy_label(ingredient_water_value, ingredient.water_energy)
	setup_energy_label(ingredient_earth_value, ingredient.earth_energy)
	setup_energy_label(ingredient_air_value, ingredient.air_energy)
	

func setup_energy_label(label: Label, value: float):
	if value == 0.0:
		label.text = ""
	else:
		label.text = "%.0f" % value



func disable_select_ingredient_button():
	select_ingredient_button.disabled = true


func enable_select_ingredient_button():
	select_ingredient_button.disabled = false

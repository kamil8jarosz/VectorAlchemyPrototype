class_name IngredientInventory
extends Control

signal ingredient_selected(ingredient_data:IngredientData)

@onready var ingredients_grid: GridContainer = %IngredientsGrid
@onready var ingredient_name_label: Label = %IngredientNameLabel
@onready var ingredient_texture: TextureRect = %IngredientTexture
@onready var ingredient_description_label: Label = %IngredientDescriptionLabel
@onready var close_button: Button = %CloseButton
@onready var select_button: Button = %SelectButton

@onready var water_energy_label: Label = %WaterEnergyLabel
@onready var fire_energy_label: Label = %FireEnergyLabel
@onready var air_energy_label: Label = %AirEnergyLabel
@onready var earth_energy_label: Label = %EarthEnergyLabel
@onready var air_label: Label = %AirLabel
@onready var fire_label: Label = %FireLabel
@onready var water_label: Label = %WaterLabel
@onready var earth_label: Label = %EarthLabel


const INGREDIENT_BUTTON = preload("uid://l3820xqp3mn7")

const DROPLET = preload("uid://dcdl6ow47tlt")
const EMBER = preload("uid://lhcs8ya01suv")
const BREEZE = preload("uid://7akj2oul1djd")
const PEBBLE = preload("uid://bsopso7xkijjj")
const OMNIESSENCE = preload("uid://ni23me2nbaq5")


var ingredients: Array[IngredientData] = []
var selected_ingredient: IngredientData


func _ready():
	select_button.pressed.connect(
		func():
			ingredient_selected.emit(selected_ingredient)
			hide()
			refresh()
	)
	
	close_button.pressed.connect(
		func():
			hide()
			refresh()
	)
	
	refresh()


func update(alchemy_progress: AlchemyProgress):
	ingredients = alchemy_progress.unlocked_ingredients
	ingredients.sort_custom(
		func(a: IngredientData, b: IngredientData):
			if a.water_energy < b.water_energy:
				return true
			if a.water_energy > b.water_energy:
				return false
			
			if a.fire_energy < b.fire_energy:
				return true
			if a.fire_energy > b.fire_energy:
				return false
			
			if a.air_energy < b.air_energy:
				return true
			if a.air_energy > b.air_energy:
				return false
			
			if a.earth_energy < b.earth_energy:
				return true
			if a.earth_energy > b.earth_energy:
				return false
			
			return true
	)
	refresh()


func refresh():
	for child in ingredients_grid.get_children():
		child.queue_free()
	
	for ingredient in ingredients:
		var ingredient_button := INGREDIENT_BUTTON.instantiate()
		ingredient_button.setup(ingredient)
		ingredient_button.pressed.connect(show_ingredient.bind(ingredient))
		ingredients_grid.add_child(ingredient_button)
	
	if ingredients:
		show_ingredient(ingredients[0])


func show_ingredient(ingredient: IngredientData):
	selected_ingredient = ingredient
	ingredient_name_label.text = ingredient.ingredient_name
	ingredient_texture.texture = ingredient.texture
	ingredient_description_label.text = ingredient.description
	
	setup_label(water_label, water_energy_label, "", ingredient.water_energy)
	setup_label(fire_label, fire_energy_label, "", ingredient.fire_energy)
	setup_label(air_label, air_energy_label, "", ingredient.air_energy)
	setup_label(earth_label, earth_energy_label, "", ingredient.earth_energy)


func setup_label(label: Label, value_label: Label, text: String, value: float):
	if value:
		label.show()
		value_label.show()
		value_label.text = "%d" % value
	else:
		label.hide()
		value_label.hide()
		value_label.text = ""

func disable_select_button():
	select_button.disabled = true


func enable_select_button():
	select_button.disabled = false
	

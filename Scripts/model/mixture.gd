class_name Mixture
extends RefCounted

var ingredients: Array[MixtureEntry] = []
var max_ingredients := 3

var selected_ingredient: IngredientData
var selected_station: ProcessingStation

func reset():
	ingredients = []
	selected_ingredient = null
	selected_station = null

func set_ingredient(ingredient: IngredientData):
	selected_ingredient = ingredient
	clear_station()


func set_station(station: ProcessingStation):
	selected_station = station


func clear_ingredient():
	selected_ingredient = null
	clear_station()


func clear_station():
	selected_station = NoProcessing.new()


func can_add() -> bool:
	return ingredients.size() < max_ingredients


func get_mixture_energy() -> Energy:
	var energy = Energy.new()
	for entry in ingredients:
		energy.add(entry.get_energy())
	
	return energy


func add_ingredient() -> bool:
	if selected_ingredient == null:
		return false
	
	if not can_add():
		return false
	
	var mixture_entry = MixtureEntry.new(selected_ingredient, selected_station)
	ingredients.append(mixture_entry)
	clear_ingredient()
	
	return true


func remove_last_ingredient() -> bool:
	if ingredients.is_empty():
		return false
	
	ingredients.pop_back()
	clear_ingredient()
	return true


func get_preview_energy() -> Energy:
	var entry = MixtureEntry.new(selected_ingredient, selected_station)
	return entry.get_energy()
	
func get_mixture_energy_with_preview() -> Energy:
	return get_preview_energy().add(get_mixture_energy())

func get_balance() -> float:
	return get_mixture_energy().get_balance()

func get_balance_with_preview() -> float:
	return get_mixture_energy_with_preview().get_balance()

class_name Mixture
extends RefCounted

var ingredients: Array[MixtureEntry] = []
var max_ingredients := 2

var entry := MixtureEntry.new() 


func reset():
	ingredients = []
	entry = MixtureEntry.new()


func is_empty():
	return ingredients.size() == 0


func is_full():
	return ingredients.size() == max_ingredients


func set_ingredient(ingredient: IngredientData):
	entry.ingredient = ingredient


func set_station(station: ProcessingStation):
	entry.station = station


func get_current_ingredient():
	return entry.ingredient


func clear_ingredient():
	entry.ingredient = null
	clear_station()


func clear_station():
	entry.station = NoProcessing.new()


func get_size() -> int:
	return ingredients.size()


func can_add() -> bool:
	return ingredients.size() < max_ingredients


func get_mixture_energy() -> Energy:
	var energy = Energy.new()
	for ingredient in ingredients:
		energy.add(ingredient.get_energy())
	
	return energy


func add_ingredient() -> bool:
	if entry.ingredient == null:
		return false
	
	if not can_add():
		return false
	
	ingredients.append(entry)
	var new_entry = MixtureEntry.new()
	new_entry.ingredient = entry.ingredient
	new_entry.station = entry.station
	entry = new_entry
	
	return true


func pop_last_ingredient() -> bool:
	if ingredients.is_empty():
		return false
	
	entry = ingredients.pop_back()
	return true


func remove_last_ingredient() -> bool:
	if ingredients.is_empty():
		return false
	
	ingredients.pop_back()
	entry = MixtureEntry.new()
	
	return true

func get_preview_energy() -> Energy:
	return entry.get_energy()
	
func get_mixture_energy_with_preview() -> Energy:
	return get_preview_energy().add(get_mixture_energy())

func get_balance() -> Vector2:
	return get_mixture_energy().get_balance()

func get_balance_with_preview() -> Vector2:
	return get_mixture_energy_with_preview().get_balance()

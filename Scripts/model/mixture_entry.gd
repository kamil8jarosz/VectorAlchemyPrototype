class_name MixtureEntry
extends RefCounted

var ingredient: IngredientData
var station: ProcessingStation


func _init(_ingredient: IngredientData, _station: ProcessingStation):
	self.ingredient = _ingredient
	self.station = _station


func get_energy() -> Energy:
	if ingredient == null:
		return Energy.new()
	
	if station == null:
		return ingredient.get_energy()
	
	return station.process(ingredient.get_energy())

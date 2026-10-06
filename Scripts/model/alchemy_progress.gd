class_name AlchemyProgress
extends RefCounted

var discovered: Array[Discovery] = []
var unlocked_ingredients: Array[IngredientData] = []
var unlocked_stations: Array[ProcessingStation] = []
var max_mixture_capacity: int = 3

func initialize(ingredients: Array[IngredientData], stations: Array[ProcessingStation]):
	for ingredient in ingredients:
		unlocked_ingredients.append(ingredient)
	
	for station in stations:
		unlocked_stations.append(station)


func is_discovered(discovery: Discovery) -> bool:
	return discovered.has(discovery)


func is_ingredient_unlocked(ingredient: IngredientData) -> bool:
	return unlocked_ingredients.has(ingredient)


func is_station_unlocked(station: ProcessingStation) -> bool:
	return unlocked_stations.has(station)


func complete(discovery: Discovery):
	if is_discovered(discovery):
		return
	
	discovered.append(discovery)
	
	for ingredient in discovery.unlocked_ingredients:
		if not is_ingredient_unlocked(ingredient):
			unlocked_ingredients.append(ingredient)
	
	for station in discovery.unlocked_stations:
		if not is_station_unlocked(station):
			unlocked_stations.append(station)
	
	if discovery.max_mixture_capacity > 0:
		max_mixture_capacity = max(max_mixture_capacity, discovery.max_mixture_capacity)

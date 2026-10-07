class_name Inventory
extends PanelContainer

signal ingredient_selected(ingredient: IngredientData)
signal station_selected(station: ProcessingStation)


@onready var ingredient_list: VBoxContainer = %IngredientList
@onready var station_list: VBoxContainer = %StationList


const STATION_ENTRY = preload("uid://cvctwupwa0pqj")
const INGREDIENT_ENTRY = preload("uid://dljuyiggnr7nu")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func update_unlocks(progress: AlchemyProgress):
	setup_ingredients(progress.unlocked_ingredients)
	setup_stations(progress.unlocked_stations)

func setup_ingredients(ingredients: Array[IngredientData]):
	for child in ingredient_list.get_children():
		child.queue_free()
	
	for ingredient in ingredients:
		var entry = INGREDIENT_ENTRY.instantiate()
		ingredient_list.add_child(entry)
		
		entry.setup(ingredient)
		entry.pressed.connect(_on_ingredient_selected.bind(entry, ingredient))


func setup_stations(stations: Array[ProcessingStation]):
	for child in station_list.get_children():
		child.queue_free()
	
	for station in stations:
		var entry = STATION_ENTRY.instantiate()
		station_list.add_child(entry)
		
		entry.setup(station)
		entry.pressed.connect(_on_station_selected.bind(entry, station))


func set_selection(ingredient: IngredientData, station: ProcessingStation):
	enable_ingredients()
	enable_stations()
	
	for entry in ingredient_list.get_children():
		if entry.ingredient == ingredient:
			entry.disabled = true
			
	for entry in station_list.get_children():
		if entry.station == station:
			entry.disabled = true


func enable_ingredients():
	for entry in ingredient_list.get_children():
		entry.disabled = false


func disable_ingredients():
	for entry in ingredient_list.get_children():
		entry.disabled = true

func enable_stations():
	for entry in station_list.get_children():
		entry.disabled = false


func disable_stations():
	for entry in station_list.get_children():
		entry.disabled = true

func _on_ingredient_selected(entry, ingredient: IngredientData):
	enable_ingredients()
	entry.disabled = true
	ingredient_selected.emit(ingredient)


func _on_station_selected(entry, station: ProcessingStation):
	enable_stations()
	entry.disabled = true
	station_selected.emit(station)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

class_name MixturePanel
extends PanelContainer

signal select_ingredient_pressed
signal discover_pressed
signal alamanac_pressed


@onready var ingredient_panel: IngredientsPanel = %IngredientPanel
@onready var station_panel: StationPanel = %StationPanel

@onready var mixture_preview: MixturePreview = %MixturePreview
@onready var discover_panel: DiscoverPanel = %DiscoverPanel
@onready var alchemy_map: AlchemyMap = %AlchemyMap

@onready var ingredient_inventory: IngredientInventory = %IngredientInventory
@onready var station_inventory: StationInventory = %StationInventory


@onready var almanac_button: Button = %AlmanacButton
@onready var discover_button: Button = %DiscoverButton

@onready var select_ingredient_button: TextureButton = %SelectIngredientButton
@onready var select_station_button: TextureButton = %SelectStationButton

@onready var reset_mixture_button: Button = %ResetMixtureButton
@onready var add_ingredient_button: Button = %AddIngredientButton
@onready var undo_button: Button = %UndoButton
@onready var remove_button: Button = %RemoveButton




var mixture: Mixture
var selected_ingredient: IngredientData
var selected_station: ProcessingStation


func _ready():
	station_panel.hide()
	
	select_ingredient_button.pressed.connect(
		func(): ingredient_inventory.show()
	)
	select_station_button.pressed.connect(
		func(): station_inventory.show()
	)
	
	ingredient_inventory.ingredient_selected.connect(display_ingredient)
	station_inventory.station_selected.connect(display_station)
	station_inventory.station_unlocked.connect(show_stations)
	
	almanac_button.pressed.connect(func():
		alamanac_pressed.emit()
	)
	
	select_ingredient_button.pressed.connect(_on_select_ingredient)
	add_ingredient_button.pressed.connect(_on_add_pressed)
	undo_button.pressed.connect(_on_undo_pressed)
	reset_mixture_button.pressed.connect(_on_reset_pressed)
	remove_button.pressed.connect(_on_remove_pressed)
	
	discover_button.pressed.connect(_on_discover_pressed)
	
	
	mixture = Mixture.new()
	mixture.max_ingredients = 2
	
	refresh_ui()


func refresh_ui():
	select_ingredient_button.disabled = false
	almanac_button.disabled = false
	
	selected_ingredient = mixture.get_current_ingredient()
	selected_station = mixture.get_current_station()
	
	ingredient_panel.display_ingredient(selected_ingredient)
	station_panel.display_station(selected_station, selected_ingredient)
	
	
	alchemy_map.set_current_position(mixture.get_balance())
	alchemy_map.set_preview_position(mixture.get_balance_with_preview())
	
	alchemy_map.set_draw_preview(true)
	
	if mixture.is_full() or selected_ingredient == null:
		alchemy_map.set_draw_preview(false)
	
	if mixture.is_empty():
		reset_mixture_button.disabled = true
		undo_button.disabled = true
		discover_button.disabled = true
		remove_button.disabled = true
	else:
		reset_mixture_button.disabled = false
		undo_button.disabled = false
		discover_button.disabled = false
		remove_button.disabled = false
	
	if mixture.is_full() or selected_ingredient == null:
		add_ingredient_button.disabled = true
	else:
		add_ingredient_button.disabled = false
		
	update_mixture_preview()


func disable_ui():
	select_ingredient_button.disabled = true
	almanac_button.disabled = true
	reset_mixture_button.disabled = true
	undo_button.disabled = true
	add_ingredient_button.disabled = true
	discover_button.disabled = true
	remove_button.disabled = true


func _on_select_ingredient():
	select_ingredient_pressed.emit()


func _on_discover_pressed():
	disable_ui()
	alchemy_map.set_draw_preview(false)
	
	alchemy_map.play_discovery_animation()
	await get_tree().create_timer(2).timeout
	
	discover_pressed.emit(mixture)
	mixture.reset()
	mixture.set_ingredient(selected_ingredient)
	mixture.set_station(selected_station)
	
	refresh_ui()


func display_ingredient(ingredient: IngredientData):
	selected_ingredient = ingredient
	mixture.set_ingredient(ingredient)

	refresh_ui()


func display_station(station: ProcessingStation):
	selected_station = station
	mixture.set_station(station)

	refresh_ui()


func _on_add_pressed():
	mixture.add_ingredient()
	update_mixture_preview()
	
	refresh_ui()


func _on_undo_pressed():
	mixture.pop_last_ingredient()
	refresh_ui()


func _on_remove_pressed():
	mixture.remove_last_ingredient()
	mixture.set_ingredient(selected_ingredient)
	mixture.set_station(selected_station)
	refresh_ui()

func _on_reset_pressed():
	mixture.reset()
	mixture.set_ingredient(selected_ingredient)
	mixture.set_station(selected_station)
	refresh_ui()


func update_mixture_preview():
	mixture_preview.update(mixture)


func set_max_mixture_capacity(new_capacity: int):
	mixture.max_ingredients = new_capacity
	update_mixture_preview()

func add_discovery(discovery: Discovery):
	alchemy_map.add_discovery(discovery)

func show_stations():
	station_panel.show()

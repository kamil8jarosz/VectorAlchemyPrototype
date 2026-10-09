extends Node

var mixture := Mixture.new()
var progress := AlchemyProgress.new()
var discovery_system: AlchemyDiscovery

@onready var inventory: Inventory = $UI/MarginContainer/VBoxContainer/MainArea/Inventory
@onready var experiment: PanelContainer = $UI/MarginContainer/VBoxContainer/MainArea/Experiment
@onready var action_bar: PanelContainer = $UI/MarginContainer/VBoxContainer/ActionBar
@onready var header: Header = $UI/MarginContainer/VBoxContainer/Header
@onready var discovery_result: DiscoveryResult = $DiscoveryResult
@onready var discovery_journal: DiscoveryJournal = $DiscoveryJournal
@onready var tutorial: Tutorial = $Tutorial

# initialization
const RAINWATER = preload("uid://bswp8od4rsyxp")
const NO_PROCESSING = preload("uid://bm3uhs44p5hc5")

const USE_RAINWATER = preload("uid://6p1ymdovdi3k")
const PERFECTLY_BALANCED = preload("uid://yaijimw35ppg")
const FIRE_SEPARATION = preload("uid://mjt5ie4e40ck")
const EXPLORING_FIRE = preload("uid://ciktus83u2ri3")
const GREATER_VESSEL = preload("uid://c43egs132gklb")


func _ready():
	progress.initialize(
		[RAINWATER],
		[NO_PROCESSING]
	)
	discovery_system = AlchemyDiscovery.new(
		[USE_RAINWATER],
		progress
	)
	
	#discovery_system.unlock_all()
	#refresh_discoveries()
	
	inventory.update_unlocks(progress)
	header.update_mixture_counter(mixture)
	refresh_action_bar()
	
	inventory.ingredient_selected.connect(_on_ingredient_selected)
	inventory.station_selected.connect(_on_station_selected)
	action_bar.undo_pressed.connect(_on_undo_pressed)
	action_bar.add_pressed.connect(_on_add_pressed)
	action_bar.discover_pressed.connect(_on_discover_pressed)
	header.discoveries_pressed.connect(_on_discoveries_pressed)
	
	tutorial.setup(
		header,
		experiment,
		inventory,
		action_bar,
		discovery_result,
		discovery_journal
	)
	tutorial.start()
	tutorial.tutorial_completed.connect(finish_tutorial)


func finish_tutorial():
	refresh_inventory()
	refresh_action_bar()
	header.enable_discoveries()


func reset_experiment():
	mixture.reset()
	action_bar.clear()
	experiment.clear()
	header.update_mixture_counter(mixture)


func refresh_action_bar():
	action_bar.show_entry(mixture.entry)
		
	if mixture.entry.ingredient:
		action_bar.enable_add_button()
	else:
		action_bar.disable_add_button()
		
	if not mixture.ingredients.is_empty():
		action_bar.enable_discover_button()
		action_bar.enable_undo_button()
	else:
		action_bar.disable_discover_button()
		action_bar.disable_undo_button()


func refresh_inventory():
	inventory.set_selection(
		mixture.entry.ingredient,
		mixture.entry.station
	)


func _on_ingredient_selected(ingredient: IngredientData):
	mixture.set_ingredient(ingredient)
	experiment.set_preview_position(mixture.get_balance_with_preview())
	
	refresh_action_bar()
	refresh_inventory()


func _on_station_selected(station: ProcessingStation):
	if mixture.entry.ingredient == null:
		return
	
	mixture.set_station(station)
	experiment.set_preview_position(mixture.get_balance_with_preview())
	refresh_action_bar()
	refresh_inventory()


func _on_undo_pressed():
	if not mixture.remove_last_ingredient():
		return
	
	experiment.set_current_position(mixture.get_balance())
	experiment.set_preview_position(mixture.get_balance_with_preview())
	refresh_action_bar()
	refresh_inventory()
	header.update_mixture_counter(mixture)


func _on_add_pressed():
	if mixture.entry.ingredient == null:
		return
	
	if not mixture.add_ingredient():
		return
	
	header.update_mixture_counter(mixture)
	experiment.set_current_position(mixture.get_balance())
	experiment.set_preview_position(mixture.get_balance_with_preview())
	
	if mixture.get_size() == mixture.max_ingredients:
		experiment.set_draw_preview(false)
	
	refresh_action_bar()
	refresh_inventory()


func _on_discover_pressed():
	if mixture.ingredients.is_empty():
		return
		
	experiment.set_draw_preview(false)
	
	var position := mixture.get_balance()
	var discovery := discovery_system.discover(position)
	
	experiment.play_discovery_animation()
	await get_tree().create_timer(1.5).timeout
	
	if discovery:
		discovery_result.show_discovery(discovery)
		tutorial.something_discovered.emit()
	else:
		discovery_result.show_failure(mixture.get_balance())
	
	refresh_discoveries()
	reset_experiment()
	refresh_action_bar()


func refresh_discoveries():
	inventory.update_unlocks(progress)
	mixture.max_ingredients = progress.max_mixture_capacity
	experiment.set_discoveries(progress.discovered)


func _on_discoveries_pressed():
	discovery_journal.show_journal(discovery_system.discoveries, progress)

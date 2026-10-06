extends Node

var mixture := Mixture.new()
var progress := AlchemyProgress.new()

@onready var inventory: Inventory = $UI/MarginContainer/VBoxContainer/MainArea/Inventory
@onready var experiment: PanelContainer = $UI/MarginContainer/VBoxContainer/MainArea/Experiment
@onready var action_bar: PanelContainer = $UI/MarginContainer/VBoxContainer/ActionBar
@onready var header: Header = $UI/MarginContainer/VBoxContainer/Header
@onready var discovery_result: DiscoveryResult = $DiscoveryResult
@onready var discovery_journal: DiscoveryJournal = $DiscoveryJournal


const RAINWATER = preload("uid://bswp8od4rsyxp")
const NO_PROCESSING = preload("uid://bm3uhs44p5hc5")

const USE_RAINWATER = preload("uid://6p1ymdovdi3k")
const MAKING_OF_STEAM = preload("uid://d3686w003xq12")
const PERFECTLY_BALANCED = preload("uid://yaijimw35ppg")
const FIRE_SEPARATION = preload("uid://mjt5ie4e40ck")
const EXPLORING_FIRE = preload("uid://ciktus83u2ri3")
const DEBUG_BIG = preload("uid://bh02jyfl6vblo")



var discoveries: Array[Discovery] = [
	USE_RAINWATER,
	MAKING_OF_STEAM,
	PERFECTLY_BALANCED,
	FIRE_SEPARATION,
	EXPLORING_FIRE
]


func _ready():
	progress.initialize(
		[RAINWATER],
		[NO_PROCESSING]
	)
	inventory.update_unlocks(progress)
	header.update_mixture_counter(0, mixture.max_ingredients)
	
	# DEBUG
	#for discovery in discoveries:
		#complete_discovery(discovery)
	
	
	inventory.ingredient_selected.connect(_on_ingredient_selected)
	inventory.station_selected.connect(_on_station_selected)
	action_bar.undo_pressed.connect(_on_undo_pressed)
	action_bar.add_pressed.connect(_on_add_pressed)
	action_bar.discover_pressed.connect(_on_discover_pressed)
	header.discoveries_pressed.connect(_on_discoveries_pressed)

func reset_experiment():
	mixture.reset()
	action_bar.clear()
	experiment.clear()
	header.update_mixture_counter(mixture.ingredients.size(), mixture.max_ingredients)


func refresh_action_bar():
	action_bar.show_ingredient(mixture.selected_ingredient)
	var preview_energy = mixture.get_preview_energy()
	action_bar.show_station(mixture.selected_station, preview_energy)


func _on_ingredient_selected(ingredient: IngredientData):
	mixture.set_ingredient(ingredient)
	
	var preview_balance = mixture.get_balance_with_preview()
	experiment.set_preview_position(preview_balance)
	refresh_action_bar()


func _on_station_selected(station: ProcessingStation):
	if mixture.selected_ingredient == null:
		return
	
	mixture.set_station(station)
	experiment.set_preview_position(mixture.get_balance_with_preview())
	refresh_action_bar()


func _on_undo_pressed():
	if not mixture.remove_last_ingredient():
		return
	
	experiment.set_current_position(mixture.get_balance())
	experiment.set_preview_position(mixture.get_balance())
	
	header.update_mixture_counter(mixture.ingredients.size(), mixture.max_ingredients)

func _on_add_pressed():
	if mixture.selected_ingredient == null:
		return
	
	if not mixture.add_ingredient():
		return
	
	header.update_mixture_counter(mixture.ingredients.size(), mixture.max_ingredients)
	experiment.set_current_position(mixture.get_balance())
	experiment.set_preview_position(mixture.get_balance())
	action_bar.clear()


func _on_discover_pressed():
	if mixture.ingredients.is_empty():
		return
	
	var discovery := find_discovery()
	experiment.play_discovery_animation(discovery)
	await get_tree().create_timer(1.5).timeout
	
	if discovery:
		complete_discovery(discovery)
		discovery_result.show_discovery(discovery)
	else:
		discovery_result.show_failure(mixture.get_balance())
		
	reset_experiment()
		

func complete_discovery(discovery):
	progress.complete(discovery)
	inventory.update_unlocks(progress)
	mixture.max_ingredients = progress.max_mixture_capacity
	experiment.set_discoveries(progress.discovered)

func find_discovery() -> Discovery:
	var position := mixture.get_balance()
	
	for discovery in discoveries:
		if progress.is_discovered(discovery):
			continue
		if discovery.contains_position(position):
			return discovery
	
	return null

func _on_discoveries_pressed():
	discovery_journal.show_journal(discoveries, progress)

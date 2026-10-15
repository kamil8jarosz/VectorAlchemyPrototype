extends Node

var progress := AlchemyProgress.new()
var discovery_system: AlchemyDiscovery


@onready var mixture_panel: MixturePanel = %MixturePanel

@onready var ingredient_inventory: IngredientInventory = $IngredientInventory
@onready var discovery_result: DiscoveryResult = %DiscoveryResult
@onready var discovery_journal: DiscoveryJournal = %DiscoveryJournal
@onready var tutorial: Tutorial = %Tutorial

const _1_USE_RAINWATER = preload("uid://c6oe7l4ggimql")
const GOING_UP = preload("uid://drxfb0o4rup3l")
const GOING_DOWN = preload("uid://flqwbgj76547")

const DROPLET = preload("uid://dcdl6ow47tlt")
const EMBER = preload("uid://lhcs8ya01suv")
const BREEZE = preload("uid://7akj2oul1djd")
const PEBBLE = preload("uid://bsopso7xkijjj")

var ingredients: Array[IngredientData] = [
	DROPLET
]


var discoveries: Array[Discovery] = [
	_1_USE_RAINWATER
]


func _ready():
	var debug := true
	if debug:
		ingredients.append_array([EMBER, BREEZE, PEBBLE])
		discoveries.append_array([GOING_UP, GOING_DOWN])
	
	progress.initialize(ingredients, [])
	progress.raise_max_mixture_capacity.connect(
		mixture_panel.set_max_mixture_capacity
	)
	discovery_system = AlchemyDiscovery.new(
		discoveries,
		progress
	)
	ingredient_inventory.update(progress)
	
	mixture_panel.select_ingredient_pressed.connect(
		func():
			ingredient_inventory.show()
	)
	
	mixture_panel.discover_pressed.connect(discover)
	
	mixture_panel.alamanac_pressed.connect(
		func():
			discovery_journal.show_journal(discoveries, progress)
	)
	
	ingredient_inventory.ingredient_selected.connect(
		mixture_panel.display_ingredient
	)
	
	tutorial.setup(
		mixture_panel, 
		ingredient_inventory
	)
	#tutorial.start()


func discover(mixture: Mixture):
	var position := mixture.get_balance()
	var discovery := discovery_system.discover(position)
	
	if discovery:
		progress.complete(discovery)
		discovery_result.show_discovery(discovery)
	else:
		discovery_result.show_failure(position)
		
	ingredient_inventory.update(progress)

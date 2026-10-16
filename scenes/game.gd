extends Node

var progress := AlchemyProgress.new()
var discovery_system: AlchemyDiscovery


@onready var mixture_panel: MixturePanel = %MixturePanel

@onready var discovery_result: DiscoveryResult = %DiscoveryResult
@onready var discovery_journal: DiscoveryJournal = %DiscoveryJournal
@onready var tutorial: Tutorial = %Tutorial



const DROPLET = preload("uid://dcdl6ow47tlt")
const EMBER = preload("uid://lhcs8ya01suv")
const BREEZE = preload("uid://7akj2oul1djd")
const PEBBLE = preload("uid://bsopso7xkijjj")

var ingredients: Array[IngredientData] = [
	DROPLET
]

const _1_USE_RAINWATER = preload("uid://c6oe7l4ggimql")
const GOING_UP = preload("uid://drxfb0o4rup3l")
const GOING_DOWN = preload("uid://flqwbgj76547")

var discoveries: Array[Discovery] = [
	_1_USE_RAINWATER
]

const NO_PROCESSING = preload("uid://bm3uhs44p5hc5")
const SEPARATION_FIRE = preload("uid://cnrq6jkphy1iv")
const SEPARATION_WATER = preload("uid://u5ibd62c0xyr")


var stations: Array[ProcessingStation] = [
	NO_PROCESSING
]



func _ready():
	var debug := false
	if debug:
		ingredients.append_array([EMBER, BREEZE, PEBBLE])
		discoveries.append_array([GOING_UP, GOING_DOWN])
		stations.append_array([SEPARATION_FIRE, SEPARATION_WATER])
	
	progress.initialize(ingredients, stations)
	progress.raise_max_mixture_capacity.connect(
		mixture_panel.set_max_mixture_capacity
	)
	discovery_system = AlchemyDiscovery.new(
		discoveries,
		progress
	)
	mixture_panel.ingredient_inventory.update(progress)
	mixture_panel.station_inventory.update(progress)
	
	mixture_panel.discover_pressed.connect(discover)
	
	mixture_panel.alamanac_pressed.connect(
		func():
			discovery_journal.show_journal(discoveries, progress)
	)
	
	tutorial.setup(
		mixture_panel, 
		mixture_panel.ingredient_inventory,
		discovery_result,
		discovery_journal
	)
	tutorial.start()


func discover(mixture: Mixture):
	var position := mixture.get_balance()
	var discovery := discovery_system.discover(position)
	
	if discovery:
		progress.complete(discovery)
		mixture_panel.add_discovery(discovery)
		discovery_result.show_discovery(discovery)
	else:
		discovery_result.show_failure(position)
		
	mixture_panel.ingredient_inventory.update(progress)
	mixture_panel.station_inventory.update(progress)
	

extends PanelContainer

signal undo_pressed
signal add_pressed
signal discover_pressed

@onready var ingredient_name: Label = %IngredientName
@onready var ingredient_fire_label: Label = %IngredientFireLabel
@onready var ingredient_water_label: Label = %IngredientWaterLabel
@onready var station_name: Label = %StationName
@onready var station_fire_label: Label = %StationFireLabel
@onready var station_water_label: Label = %StationWaterLabel
@onready var selection_info: VBoxContainer = $MarginContainer/HBoxContainer/SelectionInfo

@onready var undo_button: Button = $MarginContainer/HBoxContainer/Buttons/UndoButton
@onready var add_button: Button = $MarginContainer/HBoxContainer/Buttons/AddButton
@onready var discover_button: Button = $MarginContainer/HBoxContainer/Buttons/DiscoverButton


func show_entry(entry: MixtureEntry):
	if not entry.ingredient:
		clear()
		return
	
	if not entry.station:
		station_name.text = "NONE"
	else:
		station_name.text = entry.station.station_name
	
	ingredient_name.text = entry.ingredient.ingredient_name
	ingredient_fire_label.text = "%s" % entry.ingredient.fire_energy
	ingredient_water_label.text = "%s" % entry.ingredient.water_energy
	station_fire_label.text = "%s" % entry.get_energy().fire
	station_water_label.text = "%s" % entry.get_energy().water


func clear():
	ingredient_name.text = "NONE"
	ingredient_fire_label.text = "0.0"
	ingredient_water_label.text = "0.0"
	station_name.text = "NONE"
	station_fire_label.text = "0.0"
	station_water_label.text = "0.0"

func _ready() -> void:
	clear()
	
	undo_button.pressed.connect(func(): undo_pressed.emit())
	add_button.pressed.connect(func(): add_pressed.emit())
	discover_button.pressed.connect(func(): discover_pressed.emit())

func disable_all():
	disable_add_button()
	disable_undo_button()
	disable_discover_button()

func enable_undo_button():
	undo_button.disabled = false
	
func disable_undo_button():
	undo_button.disabled = true
	
func disable_add_button():
	add_button.disabled = true
	
func enable_add_button():
	add_button.disabled = false

func disable_discover_button():
	discover_button.disabled = true

func enable_discover_button():
	discover_button.disabled = false

class_name Tutorial
extends Control

signal tutorial_completed
signal next_pressed
signal something_discovered

@onready var highlight: Panel = $Highlight
@onready var message: PanelContainer = $Message
@onready var text: Label = $Message/Margin/Container/Text
@onready var next_button: Button = $Message/Margin/Container/Buttons/NextButton
@onready var skip_button: Button = $Message/Margin/Container/Buttons/SkipButton

var header: Control
var experiment: Control
var inventory: Control
var action_bar: Control
var discovery_result: Control
var discovery_journal: Control

func setup(
	_header: Control,
	_experiment: Control,
	_inventory: Control,
	_action_bar: Control,
	_discovery_result: Control,
	_discovery_journal: Control
):
	header = _header
	experiment = _experiment
	inventory = _inventory
	action_bar = _action_bar
	discovery_result = _discovery_result
	discovery_journal = _discovery_journal
	
	
func _ready() -> void:
	next_button.pressed.connect(_on_next_pressed)
	skip_button.pressed.connect(_on_skip_pressed)


func start():
	show()
	run_tutorial()

func run_tutorial():
	_hide_highlight()
	
	inventory.disable_ingredients()
	inventory.disable_stations()
	action_bar.disable_all()
	header.disable_discoveries()
	
	_show_message(
		"Welcome to my alchemical workshop. Ready for a guided tour?"
	)
	next_button.text = "Start"
	await next_pressed
	
	_show_message(
		"We'll be discovering new things through alchemy, by creating mixtures."
	)
	skip_button.hide()
	next_button.text = "Next"
	await next_pressed
	
	_show_message(
		"This is your alchemy line. Fire to the left. Water to the right. 
		The mixture starts at Balance. Mixture marker is the white ball.
		Adding ingredients moves the marker."
	)
	_highlight_control(experiment)
	await next_pressed
	
	_show_message(
		"Select an ingredient. The white outline is the preview of marker's "
		+ "position when you press ADD."
	)
	inventory.enable_ingredients()
	_highlight_control(inventory.ingredient_list)
	next_button.hide()
	await inventory.ingredient_selected
	
	_show_message(
		"Check the Fire and Water energy of the ingredient. Try to figure out "
		+ "how this energy corresponds to the preview's movement.",
	)
	inventory.disable_stations()
	action_bar.disable_add_button()
	_highlight_control(action_bar.selection_info)
	next_button.show()
	await next_pressed
	
	_show_message(
		"Click on ADD to add this ingredient to the mixture."
	)
	next_button.hide()
	action_bar.enable_add_button()
	_highlight_control(action_bar.add_button)
	await action_bar.add_pressed
	
	_show_message(
		"You have started your first experiment! The ingredient counter is at "
		+ "the top. Right now, the maximum capacity is 3."
	)
	inventory.disable_stations()
	action_bar.disable_all()
	_highlight_control(header.mixture_status)
	next_button.show()
	await next_pressed
	
	_show_message(
		"Now that the mixture contains some ingredients, we can use the "
		+ "current position to try to discover something new! Discoveries are "
		+ "tied to a position on the alchemy line. Try pressing the DISCOVER "
		+ "button."
	)
	next_button.hide()
	action_bar.enable_discover_button()
	_highlight_control(action_bar.discover_button)
	await action_bar.discover_pressed

	self.hide()
	await discovery_result.discovery_result_closed
	
	self.show()
	_show_message(
		"Aww, that's too bad. We need a better approach. Open up discoveries."
	)
	inventory.disable_ingredients()
	inventory.disable_stations()
	header.enable_discoveries()
	_highlight_control(header.button)
	
	await header.discoveries_pressed
	position = Vector2()
	_show_message(
		"This journal contains possible discoveries. Right now there is only "
		+ "one available, but I'm sure you'll find many more soon enough. "
	)
	discovery_journal.disable_close_button()
	next_button.show()
	await next_pressed
	
	_show_message(
		"Look at this entry. It says one ingredient is not enough, but three "
		+ "is too much. Let's go back to the experiment."
	)
	_highlight_control(discovery_journal.get_first_entry())
	await next_pressed
	
	discovery_journal.enable_close_button()
	_highlight_control(discovery_journal.close_button)
	hide()
	await discovery_journal.discovery_journal_closed
	
	_show_message(
		"Can you figure it out? Go ahead and experiment!"
	)
	show()
	_hide_highlight()
	inventory.enable_ingredients()
	inventory.enable_stations()
	await next_pressed
	
	hide()
	await something_discovered
	
	show()
	_show_message(
		"Good work! You unlocked a new ingredient and a new thing to discover. "
		+ "Discoveries can also unlock processing stations and increase your "
		+ " mixture capacity."
	)
	next_button.show()
	await next_pressed
	
	hide()
	await discovery_result.discovery_result_closed
	
	show()
	_show_message(
		"You did great. The workshop is yours. 
		Make sure to check out the new discovery. 
		Happy experimenting!"
	)
	await next_pressed
	
	tutorial_completed.emit()
	hide()

func _show_message(message_text: String):
	text.text = message_text


func _highlight_control(control: Control):
	var margin = 2.0
	highlight.global_position = control.global_position - Vector2(margin, margin)
	highlight.size = control.size + Vector2(2*margin, 2*margin)
	highlight.show()


func _hide_highlight():
	highlight.hide()


func _on_next_pressed():
	next_pressed.emit()


func _on_skip_pressed():
	_show_message(
		"Understood. I won't get in your way.\n Have fun!"
	)
	next_button.text="OK"
	skip_button.hide()
	await next_pressed
	tutorial_completed.emit()
	hide()

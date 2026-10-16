class_name Tutorial
extends Control

signal tutorial_completed
signal next_pressed

@onready var message: PanelContainer = $Message
@onready var text: Label = $Message/Margin/Container/Text
@onready var next_button: Button = $Message/Margin/Container/Buttons/NextButton
@onready var skip_button: Button = $Message/Margin/Container/Buttons/SkipButton

var mixture_panel: MixturePanel
var ingredient_inventory: IngredientInventory
var discovery_result: DiscoveryResult
var discovery_journal: DiscoveryJournal


var currently_flashing: Control
var flash_tween: Tween

enum ALIGN_H {
	LEFT,
	CENTER,
	RIGHT
}

enum ALIGN_V {
	TOP,
	CENTER,
	BOTTOM
}

var top := 50
var bottom := 340
var left := 20
var right := 620
	

func setup(
	_mixture_panel: MixturePanel,
	_ingredient_inventory: IngredientInventory,
	_discovery_result: DiscoveryResult,
	_discovery_journal: DiscoveryJournal
):
	mixture_panel = _mixture_panel
	ingredient_inventory = _ingredient_inventory
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
	
	mixture_panel.disable_ui()
	
	_show_message(
		"Welcome to my alchemical workshop!
		Ready for a guided tour?"
	)
	_align_message(
		ALIGN_H.CENTER,
		ALIGN_V.CENTER
	)
	next_button.text = "Start"
	await next_pressed
	
	_show_message(
		"We'll be discovering new things through alchemy, by creating mixtures"
		+ " and exploring alchemy map."
	)
	skip_button.hide()
	next_button.text = "Next"
	await next_pressed
	
	_show_message(
		"This is your mixture. When you add ingredients to is, its elemental energy changes."
	)
	_highlight_control(mixture_panel.mixture_preview.mixture_visuals)
	_align_message(
		ALIGN_H.CENTER, 
		ALIGN_V.TOP
	)
	await next_pressed
	
	_show_message(
		"Before we add an ingredient to the mixture, we have to select it."
		+ " Click on the glowing button. It opens ingredient inventory."
	)
	_highlight_control(mixture_panel.select_ingredient_button)
	mixture_panel.ingredient_panel.enable_select_ingredient_button()
	_align_message(
		ALIGN_H.CENTER,
		ALIGN_V.TOP
	)
	next_button.hide()
	await mixture_panel.select_ingredient_pressed
	
	_show_message(
		"Here you can inspect and choose ingredients. Right now you only have"
		+ " Droplet, but you will soon unlock many more!"
	)
	_align_message(
		ALIGN_H.CENTER,
		ALIGN_V.CENTER
	)
	ingredient_inventory.disable_select_button()
	next_button.show()
	await next_pressed
	
	_show_message(
		"The preview tells us that this ingredient has one unit of water"
		+ " energy. When your are ready, click on select to return."
	)
	_align_message(
		ALIGN_H.RIGHT,
		ALIGN_V.BOTTOM
	)
	next_button.hide()
	ingredient_inventory.enable_select_button()
	_highlight_control(ingredient_inventory.select_button)
	await ingredient_inventory.ingredient_selected
	
	_show_message(
		"Now that you have selected ingredient, you can add it to the mixture."
		+ " Click on add button."
	)
	mixture_panel.disable_ui()
	mixture_panel.mixture_preview.enable_add_button()
	_align_message(
		ALIGN_H.RIGHT,
		ALIGN_V.BOTTOM
	)
	_highlight_control(mixture_panel.add_ingredient_button)
	await mixture_panel.add_ingredient_button.pressed
	
	_show_message(
		"Good job! Right now, the maximum capacity is 2, but I have a feeling"
		+ " you can discover bigger flasks. You can see current ingredients" 
		+ " here."
	)
	mixture_panel.disable_ui()
	_highlight_control(mixture_panel.mixture_preview.mixture_contents)
	next_button.show()
	await next_pressed
	
	_show_message(
		"The mixture now contains elemental energy. The white marker has moved" 
		+ " on the alchemy map to reflect this change. You can also see the"
		+ " preview of next Add."
	)
	_align_message(
		ALIGN_H.LEFT,
		ALIGN_V.CENTER
	)
	mixture_panel.disable_ui()
	_highlight_control(mixture_panel.alchemy_map.map_node)
	next_button.show()
	await next_pressed
	
	_show_message(
		"Click on Discover to see if this location contains a discovery."
	)
	_align_message(
		ALIGN_H.CENTER,
		ALIGN_V.TOP
	)
	_hide_highlight()
	mixture_panel.discover_panel.enable_discovery_button()
	next_button.hide()
	await mixture_panel.discover_button.pressed
	
	hide()
	await discovery_result.discovery_result_closed

	_show_message(
		"Aww, that's too bad! Don't give up! We just need a more structured "
		+ " approach. Open the Almanac."
	)
	_align_message(
		ALIGN_H.CENTER,
		ALIGN_V.CENTER
	)
	_highlight_control(mixture_panel.almanac_button)
	await mixture_panel.alamanac_pressed
	
	_show_message(
		"Here you can available discoveries with hints on how to unlock them."
	)
	discovery_journal.disable_close_button()
	next_button.show()
	await next_pressed
	
	_show_message(
		"This discovery asks us to create a mixture using two droplets."
	)
	_highlight_control(discovery_journal.get_first_entry())
	_align_message(
		ALIGN_H.CENTER,
		ALIGN_V.BOTTOM
	)
	await next_pressed
	
	hide()
	discovery_journal.enable_close_button()
	await discovery_journal.discovery_journal_closed
	
	show()
	_show_message("Can you figure it out?")
	await next_pressed
	
	hide()
	await discovery_result.successful_discovery
	
	show()
	_align_message(
		ALIGN_H.CENTER,
		ALIGN_V.CENTER
	)
	_show_message(
		"Stellar work! You have unlocked a new ingredient and new discovery."
	)
	await next_pressed
	
	hide()
	await discovery_result.discovery_result_closed
	
	show()
	_show_message(
		"You did great. The workshop is yours. Make sure to check out the new"
		+ " discovery. Happy experimenting!"
	)
	_align_message(
		ALIGN_H.CENTER,
		ALIGN_V.CENTER
	)
	_hide_highlight()
	next_button.show()
	await next_pressed
	
	mixture_panel.refresh_ui()
	tutorial_completed.emit()
	hide()


func _align_message(align_h :ALIGN_H, align_v: ALIGN_V):
	var new_position = Vector2()
	match align_v:
		ALIGN_V.TOP:
			new_position.y = top
		ALIGN_V.CENTER:
			new_position.y = (top + bottom) / 2.0 - message.size.y / 2.0
		ALIGN_V.BOTTOM:
			new_position.y = bottom - message.size.y
	
	match align_h:
		ALIGN_H.LEFT:
			new_position.x = left
		ALIGN_H.CENTER:
			new_position.x = (left + right) / 2.0 - message.size.x / 2.0
		ALIGN_H.RIGHT:
			new_position.x = right - message.size.x
			
	_reposition_message(new_position)


func _reposition_message(new_position: Vector2):
	message.global_position = new_position


func _show_message(message_text: String):
	hide()
	text.text = message_text
	show()
	

func stop_flashing():
	if currently_flashing:
		currently_flashing.modulate.a = 1.0
		
	if flash_tween:
		flash_tween.kill()


func start_flashing(control: Control):
	currently_flashing = control
	flash_tween = create_tween().set_loops()
	flash_tween.tween_property(control, "modulate:a", 0.6, 0.2)
	flash_tween.tween_property(control, "modulate:a", 1.0, 0.2)


func _highlight_control(control: Control):
	stop_flashing()
	start_flashing(control)


func _hide_highlight():
	stop_flashing()


func _on_next_pressed():
	next_pressed.emit()


func _on_skip_pressed():
	_show_message(
		"Understood. I won't get in your way.\n Have fun!"
	)
	next_button.text="OK"
	skip_button.hide()
	await next_pressed
	mixture_panel.refresh_ui()
	tutorial_completed.emit()
	hide()

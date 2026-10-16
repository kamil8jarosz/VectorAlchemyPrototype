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

var currently_flashing: Control
var flash_tween: Tween

enum ALIGN_H {
	LEFT,
	MID_LEFT,
	CENTER,
	MID_RIGHT,
	RIGHT
}

enum ALIGN_V {
	TOP,
	MID_TOP,
	CENTER,
	MID_BOTTOM,
	BOTTOM
}

var top := 50
var bottom := 340
var left := 20
var right := 620
	

func setup(
	_mixture_panel: MixturePanel,
	_ingredient_inventory: IngredientInventory,
):
	mixture_panel = _mixture_panel
	ingredient_inventory = _ingredient_inventory
	
	
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
		"We'll be discovering new things through alchemy, by creating mixtures
		and exploring alchemy map."
	)
	skip_button.hide()
	next_button.text = "Next"
	await next_pressed
	
	_show_message(
		"This is your mixture. As you add ingredients, its elemental energy 
		will change, which moves the marker on the alchemy map. 
		Speaking of which..."
	)
	_highlight_control(mixture_panel.mixture_preview)
	_align_message(
		ALIGN_H.CENTER, 
		ALIGN_V.BOTTOM
	)
	await next_pressed
	
	_show_message(
		"This is your alchemy map. Fire to the left. Water to the right. "
		+ "The mixture starts at Balance. Mixture marker is the white ball. "
		+ "Adding ingredients moves the marker."
	)
	_highlight_control(mixture_panel.alchemy_map)
	_align_message(
		ALIGN_H.LEFT, 
		ALIGN_V.CENTER
	)
	await next_pressed
	
	_show_message(
		"You did great. The workshop is yours. 
		Make sure to check out the new discovery. 
		Happy experimenting!"
	)
	_align_message(
		ALIGN_H.CENTER,
		ALIGN_V.CENTER
	)
	_hide_highlight()
	await next_pressed
	
	mixture_panel.refresh_ui()
	tutorial_completed.emit()
	hide()


func _align_message(align_h :ALIGN_H, align_v: ALIGN_V):
	var new_position = Vector2()
	match align_v:
		ALIGN_V.TOP:
			new_position.y = top
		ALIGN_V.MID_TOP:
			new_position.y = (2*top + bottom) / 3.0
		ALIGN_V.CENTER:
			new_position.y = (top + bottom) / 2.0 - message.size.y / 2.0
		ALIGN_V.MID_BOTTOM:
			new_position.y = (top + 2*bottom) / 3.0
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
	flash_tween.tween_property(control, "modulate:a", 0.6, 0.5)
	flash_tween.tween_property(control, "modulate:a", 1.0, 0.5)


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

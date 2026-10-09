class_name Header
extends PanelContainer

signal discoveries_pressed

@onready var button: Button = $MarginContainer/HBoxContainer/Button
@onready var mixture_counter: Label = %MixtureCounter
@onready var mixture_status: HBoxContainer = $MarginContainer/HBoxContainer/MixtureStatus


func _ready() -> void:
	mixture_counter.text = "0/0"
	button.pressed.connect(_on_discoveries_pressed)


func update_mixture_counter(mixture):
	var current = mixture.ingredients.size() 
	var max_counter = mixture.max_ingredients
	
	mixture_counter.text = "%s/%s" % [current, max_counter]
	if current == max_counter:
		%MixtureCounter.set("theme_override_colors/font_color", Color("red"))
	else:
		%MixtureCounter.set("theme_override_colors/font_color", Color("white"))

func _on_discoveries_pressed():
	discoveries_pressed.emit()


func disable_discoveries():
	button.disabled = true


func enable_discoveries():
	button.disabled = false

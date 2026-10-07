class_name Header
extends PanelContainer

signal discoveries_pressed

@onready var button: Button = $MarginContainer/HBoxContainer/Button
@onready var mixture_counter: Label = %MixtureCounter


func _ready() -> void:
	mixture_counter.text = "0/0"
	button.pressed.connect(_on_discoveries_pressed)


func update_mixture_counter(current, max_counter):
	mixture_counter.text = "%s/%s" % [current, max_counter]
	if current == max_counter:
		%MixtureCounter.set("theme_override_colors/font_color", Color("red"))
	else:
		%MixtureCounter.set("theme_override_colors/font_color", Color("white"))

func _on_discoveries_pressed():
	discoveries_pressed.emit()

class_name Header
extends PanelContainer

signal discoveries_pressed

@onready var mixture_counter: Label = $MarginContainer/HBoxContainer/MixtureCounter
@onready var button: Button = $MarginContainer/HBoxContainer/Button


func _ready() -> void:
	mixture_counter.text = "0/0"
	button.pressed.connect(_on_discoveries_pressed)


func update_mixture_counter(current, max_counter):
	mixture_counter.text = "%s/%s" % [current, max_counter]
	

func _on_discoveries_pressed():
	discoveries_pressed.emit()

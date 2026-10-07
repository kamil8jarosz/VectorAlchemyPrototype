extends Control

@onready var confirm_button: Button = $Panel/Margin/Content/ConfirmButton



func _ready():
	show()
	confirm_button.pressed.connect(_on_ok_pressed)

func _on_ok_pressed():
	hide()

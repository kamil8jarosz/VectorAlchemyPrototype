class_name AlmanacPanel
extends PanelContainer

signal almanac_pressed

@onready var almanac_button: Button = %AlmanacButton

func _ready():
	almanac_button.pressed.connect(
		func():
			almanac_pressed.emit()
	)


func disable_almanac_button():
	almanac_button.disabled = true


func enable_almanac_button():
	almanac_button.disabled = false

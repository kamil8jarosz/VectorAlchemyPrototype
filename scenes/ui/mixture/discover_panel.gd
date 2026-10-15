class_name DiscoverPanel
extends PanelContainer

signal discover_pressed

@onready var discover_button: Button = %DiscoverButton

func _ready():
	discover_button.pressed.connect(
		func():
			discover_pressed.emit()
	)

func disable_discovery_button():
	discover_button.disabled = true

func enable_discovery_button():
	discover_button.disabled = false

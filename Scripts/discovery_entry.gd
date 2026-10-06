class_name DiscoveryEntry
extends PanelContainer

@onready var name_label: Label = $Margin/Content/Name
@onready var text_label: Label = $Margin/Content/Text


func setup(discovery: Discovery, is_discovered: bool):
	if is_discovered:
		name_label.text = "O " + discovery.discovery_name
		text_label.text = discovery.description
		_set_discovered_style()
	else:
		name_label.text = "X " + discovery.discovery_name
		text_label.text = discovery.hint
		_set_undiscovered_style()

func _set_discovered_style() -> void:
	var style := StyleBoxFlat.new()
	style.bg_color = Color("#1c1c1c")
	style.border_width_left = 1
	style.border_width_top = 1
	style.border_width_right = 1
	style.border_width_bottom = 1
	style.border_color = Color("#444444")

	add_theme_stylebox_override("panel", style)

	name_label.add_theme_color_override("font_color", Color("#ffffff"))
	text_label.add_theme_color_override("font_color", Color("#bbbbbb"))


func _set_undiscovered_style() -> void:
	var style := StyleBoxFlat.new()
	style.bg_color = Color("#101010")
	style.border_width_left = 1
	style.border_width_top = 1
	style.border_width_right = 1
	style.border_width_bottom = 1
	style.border_color = Color("#222222")

	add_theme_stylebox_override("panel", style)

	name_label.add_theme_color_override("font_color", Color("#888888"))
	text_label.add_theme_color_override("font_color", Color("#666666"))

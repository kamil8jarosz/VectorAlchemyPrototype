class_name Experiment
extends PanelContainer

@onready var alchemy_line: AlchemyLine = %AlchemyLine
@onready var margin_container: MarginContainer = $MarginContainer

func _ready():
	pass


func clear():
	set_current_position(0.0)
	set_preview_position(0.0)
	set_draw_preview(false)


func set_draw_preview(value: bool):
	alchemy_line.set_draw_preview(value)

func set_current_position(new_position: float):
	alchemy_line.set_current_position(new_position)


func set_preview_position(new_position: float):
	alchemy_line.set_preview_position(new_position)
	alchemy_line.set_draw_preview(true)


func play_discovery_animation():
	alchemy_line.play_discovery_animation()


func set_discoveries(discoveries: Array[Discovery]):
	alchemy_line.set_discoveries(discoveries)

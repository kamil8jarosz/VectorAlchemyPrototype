class_name Experiment
extends PanelContainer

@onready var alchemy_line: AlchemyLine = %AlchemyLine

func clear():
	alchemy_line.set_current_position(0.0)
	alchemy_line.set_preview_position(0.0)


func set_current_position(new_position: float):
	alchemy_line.set_current_position(new_position)


func set_preview_position(new_position: float):
	alchemy_line.set_preview_position(new_position)


func play_discovery_animation():
	alchemy_line.play_discovery_animation()

func set_discoveries(discoveries: Array[Discovery]):
	alchemy_line.set_discoveries(discoveries)

class_name Experiment
extends PanelContainer

@onready var number_line: NumberLine = $ExperimentArea/MarginContainer/NumberLine

func clear():
	number_line.set_current_position(0.0)
	number_line.set_preview_position(0.0)


func set_current_position(new_position: float):
	number_line.set_current_position(new_position)


func set_preview_position(new_position: float):
	number_line.set_preview_position(new_position)


func set_discoveries(discoveries: Array[Discovery]):
	number_line.set_discoveries(discoveries)

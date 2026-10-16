class_name MixtureVisuals
extends PanelContainer

var energy: Energy

func _make_custom_tooltip(for_text: String) -> Object:
	var tooltip: MixtureTooltip = preload("uid://b40ec8vu0h5ix").instantiate()
	print(for_text)
	tooltip.setup(energy)
	return tooltip

func set_mixture_energy(_energy):
	energy = _energy

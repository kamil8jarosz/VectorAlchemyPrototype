class_name SeparationFStation
extends ProcessingStation

func _init():
	super("Separate F")
	
func process(energy: Energy):
	return Energy.new(0.0, energy.fire)

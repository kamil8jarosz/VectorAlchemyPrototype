class_name SeparationFStation
extends ProcessingStation

func _init():
	super("Separate Fire")
	
func process(energy: Energy):
	return Energy.new(0.0, energy.fire)

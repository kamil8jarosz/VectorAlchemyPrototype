class_name SeparationWStation
extends ProcessingStation

func _init():
	super("Separate Water")
	
func process(energy: Energy):
	return Energy.new(energy.water, 0.0)

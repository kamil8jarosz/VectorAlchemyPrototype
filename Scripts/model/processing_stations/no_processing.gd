class_name NoProcessing
extends ProcessingStation

func _init():
	super("NONE")
	
func process(energy: Energy):
	return energy

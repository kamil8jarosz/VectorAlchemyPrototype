class_name NullWStation
extends ProcessingStation

func _init():
	super("Water Nullifier")
	
func process(energy: Energy):
	return Energy.new(
		0.0, 
		energy.fire,
		energy.earth,
		energy.air
	)

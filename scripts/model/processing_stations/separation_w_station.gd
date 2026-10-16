class_name NullFStation
extends ProcessingStation

func _init():
	super("Null Fire")
	
func process(energy: Energy):
	return Energy.new(
		energy.water, 
		0.0,
		energy.earth,
		energy.air
	)

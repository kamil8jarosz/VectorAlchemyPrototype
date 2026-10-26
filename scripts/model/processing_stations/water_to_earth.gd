extends ProcessingStation
class_name WaterToEarth

func _init():
	super("Water To Earth Transmutation")
	
func process(energy: Energy):
	return Energy.new(
		0.0, 
		energy.fire,
		energy.earth + energy.water,
		energy.air
	)

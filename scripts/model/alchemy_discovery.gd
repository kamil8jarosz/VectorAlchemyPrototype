class_name AlchemyDiscovery
extends RefCounted

var discoveries: Array[Discovery]
var progress: AlchemyProgress

func _init(
	_discoveries: Array[Discovery],
	_progress: AlchemyProgress
):
	discoveries = _discoveries
	progress = _progress


func discover_at_position(position: Vector2, energy: Energy) -> Discovery:
	var discovery := find_at_position(position, energy)
	discover_discovery(discovery)
	return discovery
	

func discover_discovery(discovery: Discovery):
	if discovery and discovery.unlocked_discoveries:
		for new_discovery in discovery.unlocked_discoveries:
			discoveries.append(new_discovery)
	
	return discovery


func find_at_position(position: Vector2, energy: Energy) -> Discovery:
	for discovery in discoveries:
		if progress.is_discovered(discovery):
			continue
		
		if(
			discovery.contains_position(position) 
			and discovery.fulfills_energy_req(energy)
		):
			return discovery
		
	return null


# DEBUG FUNCTIONS

func get_next() -> Discovery:
	for discovery in discoveries:
		if progress.is_discovered(discovery):
			continue
		return discovery
	
	return null
		

func unlock_all():
	for discovery in discoveries:
		progress.complete(discovery)

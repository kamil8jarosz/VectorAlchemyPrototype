class_name AlchemyMap
extends Control

@onready var map_node: MapNode = %MapNode


func set_draw_preview(value: bool):
	map_node.set_draw_preview(value)


func set_preview_position(new_position: Vector2):
	map_node.set_preview_position(new_position)


func set_current_position(new_position: Vector2):
	map_node.set_current_position(new_position)


func add_discovery(discovery: Discovery):
	map_node.add_discovery(discovery)


func play_discovery_animation():
	map_node.play_discovery_animation()

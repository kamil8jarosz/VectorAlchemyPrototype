class_name DiscoveryResult
extends Control

@onready var title: Label = $Panel/Margin/Content/Title
@onready var discovery_name: Label = $Panel/Margin/Content/DiscoveryName
@onready var description: Label = $Panel/Margin/Content/Description
@onready var rewards_label: Label = $Panel/Margin/Content/RewardsLabel
@onready var rewards: VBoxContainer = $Panel/Margin/Content/Rewards
@onready var ok_button: Button = $Panel/Margin/Content/OKButton

const REWARD_LABEL = preload("uid://bb0244062umtd")


func _ready():
	hide()
	ok_button.pressed.connect(_on_ok_pressed)


func show_discovery(discovery: Discovery):
	title.text = "Discovery!"
	discovery_name.text = discovery.discovery_name
	description.text = discovery.description
	
	_clear_rewards()
	_add_rewards(discovery)
	
	show()


func show_failure(_position: float):
	title.text = "NO DISCOVERY!"
	discovery_name.text = ""
	description.text = "The mixture revealed nothing new."
	
	_clear_rewards()
	
	var position_label := REWARD_LABEL.instantiate()
	position_label.text = "Position: %s" % _position
	rewards.add_child(position_label)
	
	rewards_label.text = ""
	
	show()


func _add_rewards(discovery: Discovery):
	for ingredient in discovery.unlocked_ingredients:
		_add_reward("New ingredient: %s" % ingredient.ingredient_name)
		
	for station in discovery.unlocked_stations:
		_add_reward("New station: %s" % station.station_name)
		
	if discovery.max_mixture_capacity > 0:
		_add_reward(
			"Mixture capacity: %d" % discovery.max_mixture_capacity
		)


func _add_reward(text: String):
	var label = REWARD_LABEL.instantiate()
	label.text = text
	rewards.add_child(label)


func _clear_rewards():
	for child in rewards.get_children():
		child.queue_free()


func _on_ok_pressed():
	hide()

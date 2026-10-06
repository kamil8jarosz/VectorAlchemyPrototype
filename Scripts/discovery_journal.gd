class_name DiscoveryJournal
extends Control

const DISCOVERY_ENTRY = preload("uid://bufdo4gxrxkvb")

@onready var discovery_list: VBoxContainer = %DiscoveryList
@onready var close_button: Button = %CloseButton


func _ready():
	hide()
	close_button.pressed.connect(_on_close_pressed)


func show_journal(
	discoveries: Array[Discovery],
	progress: AlchemyProgress
):
	_clear_entries()
	
	for discovery in discoveries:
		var entry: DiscoveryEntry = DISCOVERY_ENTRY.instantiate()
		var discovered := progress.is_discovered(discovery)
		
		discovery_list.add_child(entry)
		entry.setup(discovery, discovered)
		
	show()


func _clear_entries():
	for child in discovery_list.get_children():
		child.queue_free()


func _on_close_pressed():
	hide()

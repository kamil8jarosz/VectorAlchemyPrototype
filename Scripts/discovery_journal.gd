class_name DiscoveryJournal
extends Control

signal discovery_journal_closed

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


func get_first_entry() -> Node:
	var children = discovery_list.get_children()
	if not children:
		return null
	return children[0]


func disable_close_button():
	close_button.disabled = true


func enable_close_button():
	close_button.disabled = false


func _on_close_pressed():
	discovery_journal_closed.emit()
	hide()

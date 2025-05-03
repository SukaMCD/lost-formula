extends VBoxContainer


func _on_inventory_item_changed() -> void:
	for repice in get_children():
		repice.check()

extends PanelContainer

var item: Item = null:
	set(value):
		item = value
		if value != null:
			$TextureRect.texture = value.icon
		else:
			$TextureRect.texture = null
			
func enable(value = true):
	var inventory = get_tree().current_scene.find_child("Inventory")
	$Panel.show_behind_parent = value
	return enable(inventory.is_available(item))

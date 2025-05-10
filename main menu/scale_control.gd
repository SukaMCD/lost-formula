extends OptionButton


func _on_item_selected(index: int) -> void:
	var settings = [1, 0.75, 0.5, 0.25]
	var value = settings[index]
	print(value)
	get_tree().root.scaling_3d_scale = value

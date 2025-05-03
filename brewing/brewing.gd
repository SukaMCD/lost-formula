extends PanelContainer
class_name Slot 

@onready var texture_rect: TextureRect = $TextureRect

@export var item: Item = null:
	set(value):
		item = value
		if value != null:
			texture_rect.texture = value.icon
		else:
			texture_rect.texture = null

func get_preview() -> Control:
	var preview_texture := TextureRect.new()
	preview_texture.texture = texture_rect.texture

	var preview := Control.new()
	preview.add_child(preview_texture)

	return preview

func _get_drag_data(at_position: Vector2) -> Variant:
	set_drag_preview(get_preview())
	return self

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data is Slot

func _drop_data(at_position: Vector2, data: Variant) -> void:
	if data is Slot:
		var temp = item
		item = data.item
		data.item = temp

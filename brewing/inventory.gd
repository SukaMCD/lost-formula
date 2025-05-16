extends GridContainer

signal item_changed

#region New Code Region
@export var ITEM : Item
@export var ITEM2 : Item
@export var ITEM3 : Item
@export var ITEM4 : Item

func _ready():
	await get_tree().create_timer(2).timeout
	add_item(ITEM)

	await get_tree().create_timer(2).timeout
	add_item(ITEM2)
	
	await get_tree().create_timer(2).timeout
	add_item(ITEM3)
	
	await get_tree().create_timer(2).timeout
	add_item(ITEM4)
#endregion

func add_item(item):
	for i in get_children():
		if i.item == null:
			i.item = item
			item_changed.emit()
			show_crafting_dialog("Berhasil menambahkan item: " + item.name)
			return

func remove_item(item):
	for i in get_children():
		if i.item == item:
			i.item = null
			item_changed.emit()
			return
			
func is_available(item):
	for i in get_children():
		if i.item == item:
			return true
	return false

func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Gubuk/Dalem_Gubuk.tscn")

func show_crafting_dialog(text: String):
	var label_node = $CraftingDialogLabel
	if label_node:
		label_node.text = text
		label_node.visible = true
		await get_tree().create_timer(2.0).timeout
		label_node.visible = false

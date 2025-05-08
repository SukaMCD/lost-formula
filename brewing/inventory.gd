extends GridContainer

signal item_changed

#region New Code Region
@export var ITEM : Item
@export var ITEM2 : Item
@export var ITEM3 : Item
@export var ITEM4 : Item

func _ready():
	await get_tree().create_timer(0.1).timeout
	add_item(ITEM)

	await get_tree().create_timer(0.1).timeout
	add_item(ITEM2)
	
	await get_tree().create_timer(0.1).timeout
	add_item(ITEM3)
	
	await get_tree().create_timer(0.1).timeout
	add_item(ITEM4)
#endregion

func add_item(item):
	for i in get_children():
		if i.item == null:
			i.item = item
			item_changed.emit()
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

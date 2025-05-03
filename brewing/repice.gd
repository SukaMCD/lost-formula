extends HBoxContainer

@onready var craft = $craft
@export var item: Item = null
var recipe = []

func _ready():
	if item == null:
		print("❗ Item belum di-assign!")
		return
	
	recipe = item.recipe
	craft.icon = item.icon
	
	for i in range(recipe.size()):
		var child = get_child(i)
		if child.has_variable("item"):
			child.item = recipe[i]
		else:
			print("❗ Child ke-%d tidak punya properti 'item'" % i)
		
func check():
	var flag = []
	
	for i in range(recipe.size()):
		var child = get_child(i)
		if child.has_method("check"):
			flag.append(child.check())
		else:
			flag.append(false)  # Asumsikan gagal kalau gak punya fungsi check
	
	if false not in flag:
		craft.disabled = false
	else:
		craft.disabled = true

func _on_craft_pressed() -> void:
	craft.disabled = true
	var inventory = get_tree().current_scene.find_child("Inventory")
	
	if inventory == null:
		print("❗ Inventory tidak ditemukan di scene!")
		return
	
	for i in recipe:
		if inventory.has_method("remove_item"):
			inventory.remove_item(i)
	
	if inventory.has_method("add_item"):
		inventory.add_item(item)

extends HBoxContainer

@onready var craft = $craft
@export var item: Item = null
@onready var recipe = item.recipe

func _ready() -> void:
	craft.icon = item.icon
	
	for i in range(recipe.size()):
		get_child(i).item = recipe[i]

func check():
	var flag = []

	for i in range(recipe.size()):
		flag.append(get_child(i).check())

	if false not in flag:
		craft.disabled = false

func _on_craft_pressed() -> void:
	craft.disabled = true
	var inventory = get_tree().current_scene.find_child("Inventory")
	
	for i in recipe:
		inventory.remove_item(i)
	inventory.add_item(item)

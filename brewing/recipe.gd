extends HBoxContainer

@onready var craft = $craft
@export var item: Item = null
var recipe = []

func _ready() -> void:
	if item == null:
		push_error("Item belum di-set!")
		return

	recipe = item.recipe
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
	
	$Brew.play()
	await get_tree().create_timer(1.5).timeout
	
	for i in recipe:
		inventory.remove_item(i)
	inventory.add_item(item)

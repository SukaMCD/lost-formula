extends Control

@export var base_button: PackedScene
@export var total_levels: int = 0
@export var grid: NodePath

func _ready():
	var grid_node = get_node(grid)  # Ambil node GridContainer

	if total_levels > 2:  # Perbaikan logika kondisi
		column_size(grid_node)

	for i in range(0, total_levels):
		generate_buttons(i + 1, grid_node)

func generate_buttons(name: int, grid_node):
	var bb = base_button.instantiate()  # `instance()` diubah ke `instantiate()` di Godot 4
	bb.name = str(name)  # Set nama tombol
	bb.text = str(name)  # Set teks tombol
	bb.level_path = "res://Scenes/Worlds/World_percobaan.tscn" + str(name) + ".tscn"  # Perbaikan path level
	grid_node.add_child(bb)  # Tambahkan tombol ke grid

func column_size(grid_node):
	if total_levels % 2 == 0:
		grid_node.columns = total_levels / 2
	else:
		grid_node.columns = (total_levels / 2) + 1

func print_loading_level():
	$Label_loading.text = "Loading..."
	$Label_loading.visible_characters = 7
	for _i in range(0, 3):
		$Label.visible_characters += 1
		await get_tree().create_timer(0.3).timeout

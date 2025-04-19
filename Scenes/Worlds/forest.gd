extends Node2D

# Di script Main/World scene
func _ready():
	var pause_menu = preload("res://UI/paused_menu.tscn").instantiate()
	add_child(pause_menu)

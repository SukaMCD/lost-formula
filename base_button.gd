extends Button

var level_path: String = "res://World_percobaan.tscn"

func _on_pressed() -> void:
	get_tree().change_scene_to_file(level_path)

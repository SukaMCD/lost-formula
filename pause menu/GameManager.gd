extends Node

class_name GameManager

signal toggle_game_paused(is_pause : bool)

var game_paused : bool = false:
	get: 
		return game_paused
	set(value):
		game_paused = value
		get_tree().paused = value  # <- diperbaiki di sini
		emit_signal("toggle_game_paused", game_paused)

func _input(event: InputEvent):
	if event.is_action_pressed("ui_cancel"):
		game_paused = !game_paused  # <- pake properti, bukan langsung ke get_tree().paused

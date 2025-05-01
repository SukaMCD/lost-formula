extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_video_stream_player_finished() -> void:
	animation_player.play("Fade_out")
	get_tree().change_scene_to_file("res://Scenes/Worlds/level_2.tscn")

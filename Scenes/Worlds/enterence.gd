extends Area2D

@onready var anim_player = $"../AnimationPlayer"  # arahkan ke AnimationPlayer
@onready var fade = $"../CanvasLayer/ColorRect"   # pastikan path ini sesuai

func _on_body_entered(_body: Node2D) -> void:
	# Mainkan animasi fade
	anim_player.play("Fade_out")

	# Tunggu animasi selesai
	await anim_player.animation_finished

	# Ganti scene setelah fade selesai
	get_tree().change_scene_to_file("res://Scenes/Player/forest.tscn")

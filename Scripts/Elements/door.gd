extends Area2D
class_name Door

@export var destination_level_path: String  # Path scene tujuan, bisa diatur dari editor
@export var destination_Door_tag: String    # Nama pintu tujuan di scene baru
@export var spawn_direction: String = "up"  # Arah spawn (untuk rotasi karakter, opsional)

@onready var spawn = $Spawn
@onready var fade_rect = $CanvasLayer/ColorRect
@onready var anim = $CanvasLayer/AnimationPlayer

var next_scene_path: String = ""

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if destination_level_path == "":
			push_warning("Tujuan level belum di-set!")
			return

		next_scene_path = destination_level_path
		print("Pindah ke: ", next_scene_path)
		anim.play("fade_in")  # Transisi keluar

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "fade_in":
		# Pindah ke scene baru setelah animasi fade selesai
		get_tree().change_scene_to_file(next_scene_path)

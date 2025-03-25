extends CanvasLayer

var world_percobaan = load("res://Scenes/Worlds/World_percobaan.tscn") as PackedScene

signal on_trigger_player_spawn

var spawn_door_tag

func go_to_level(level_tag, destination_tag):
	var scene_to_load

	match level_tag:
		"level_1":
			scene_to_load = world_percobaan

signal on_transition_finished

@onready var anim_player = $AnimationPlayer
@onready var color_rect = $ColorRect  # Ambil ColorRect buat animasi


func transition():
	anim_player.play("fade_to_black")  # Mulai transisi keluar
	await anim_player.animation_finished
	on_transition_finished.emit()  # Kirim sinyal kalau transisi selesai
	anim_player.play("fade_to_normal")  # Transisi masuk kembali

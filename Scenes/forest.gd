extends Node2D

var kunyit_collected := false  # Hanya ini yang dibutuhkan di level ini

@onready var transition = $CanvasLayer2/AnimationPlayer
@onready var forest_sound = $AudioStreamPlayer2D

func _ready():
	transition.play("Fade_out")
	forest_sound.volume_db = -40
	forest_sound.play()
	fade_in_sound()

func fade_in_sound():
	var target_volume = 0
	var fade_speed = 1.0

	while forest_sound.volume_db < target_volume:
		forest_sound.volume_db += fade_speed
		await get_tree().create_timer(0.1).timeout

# Fungsi untuk cek apakah pemain boleh lanjut
func can_proceed_to_next_scene() -> bool:
	return kunyit_collected

extends Node2D

@onready var transition = $CanvasLayer2/AnimationPlayer
@onready var forest_sound = $AudioStreamPlayer2D

func _ready():
	transition.play("Fade_out")
	forest_sound.volume_db = -40 # Mulai dari volume kecil biar fade in smooth
	forest_sound.play()
	fade_in_sound()

func fade_in_sound():
	var target_volume = 0 # Target volume normal
	var fade_speed = 1.0 # Kecepatan fade in

	while forest_sound.volume_db < target_volume:
		forest_sound.volume_db += fade_speed
		await get_tree().create_timer(0.1).timeout
